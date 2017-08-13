package main

import (
	"io"
	"log"
	"net"
	"time"

	"golang.org/x/net/context"

	"google.golang.org/grpc"

	pb "../route"
)

type routeGuideServer struct {
	savedFeatures []*pb.Feature
}

func (s *routeGuideServer) GetFeature(ctx context.Context, point *pb.Point) (*pb.Feature, error) {
	return &pb.Feature{"", point}, nil
}

func (s *routeGuideServer) ListFeatures(rect *pb.Rectangle, stream pb.RouteGuide_ListFeaturesServer) error {
	for _, feature := range s.savedFeatures {
		if err := stream.Send(feature); err != nil {
			return err
		}
	}
	return nil
}

func (s *routeGuideServer) RecordRoute(stream pb.RouteGuide_RecordRouteServer) error {
	var pointCount, featureCount, distance int32
	startTime := time.Now().Unix()
	for {
		point, err := stream.Recv()
		if err == io.EOF {
			return stream.SendAndClose(&pb.RouteSummary{
				PointCount:   pointCount,
				FeatureCount: featureCount,
				Distance:     distance,
				ElapsedTime:  int32(time.Now().Unix() - startTime),
			})
		}
		if err != nil {
			return err
		}
		log.Println(point)
		pointCount++
		featureCount++

	}
}

func (s *routeGuideServer) RouteChat(stream pb.RouteGuide_RouteChatServer) error {
	notes := []*pb.RouteNote{
		&pb.RouteNote{
			Location: &pb.Point{
				Latitude:  10000,
				Longitude: 10000,
			},
			Message: "Hello world",
		},
	}
	for {
		in, err := stream.Recv()
		if err == io.EOF {
			return nil
		}
		if err != nil {
			return err
		}
		log.Println(in)

		for _, note := range notes {
			if err := stream.Send(note); err != nil {
				return err
			}
		}
	}
}

func main() {
	lis, err := net.Listen("tcp", ":55001")
	if err != nil {
		log.Fatalf("failed to listen: %v\n", err)
	}

	grpcServer := grpc.NewServer()
	server := routeGuideServer{
		savedFeatures: []*pb.Feature{
			&pb.Feature{
				Name: "feature_1",
				Location: &pb.Point{
					Latitude:  1000,
					Longitude: 1000,
				},
			},
			&pb.Feature{
				Name: "feature_2",
				Location: &pb.Point{
					Latitude:  1000,
					Longitude: 1000,
				},
			},
		},
	}
	pb.RegisterRouteGuideServer(grpcServer, &server)
	log.Println("Listening to server at port *:55001")
	grpcServer.Serve(lis)
}
