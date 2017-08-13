package main

import (
	"context"
	"io"
	"log"
	"time"

	pb "../route"
	"google.golang.org/grpc"
)

type grpcClient struct {
	client pb.RouteGuideClient
}

func (grpc grpcClient) GetFeature() {
	feature, err := grpc.client.GetFeature(context.Background(), &pb.Point{409146138, -746188906})
	if err != nil {
		log.Printf("Error getting feature: %v\n", err)
	}
	log.Printf("Got feature: %v\n", feature)
}

func (grpc grpcClient) ListFeatures() {

	rect := &pb.Rectangle{
		Lo: &pb.Point{
			Latitude:  10000,
			Longitude: 10000,
		},
		Hi: &pb.Point{
			Latitude:  10000,
			Longitude: 10000,
		},
	}
	stream, err := grpc.client.ListFeatures(context.Background(), rect)
	if err != nil {
		log.Fatal(err)
	}
	for {
		feature, err := stream.Recv()
		if err == io.EOF {
			break
		}
		if err != nil {
			log.Fatalf("%v.ListFeatures(_) = _, %v", grpc.client, err)
		}
		log.Println(feature)
	}
}

func (grpc grpcClient) RecordRoute() {
	var points []*pb.Point
	for i := 0; i < 10; i++ {
		points = append(points, &pb.Point{
			Latitude:  int32(time.Now().Unix()),
			Longitude: int32(time.Now().Unix()),
		})
	}
	stream, err := grpc.client.RecordRoute(context.Background())
	if err != nil {
		log.Fatal(err)
	}
	for _, point := range points {
		if err := stream.Send(point); err != nil {
			log.Fatal(err)
		}
	}
	reply, err := stream.CloseAndRecv()
	if err != nil {
		log.Fatal(err)
	}
	log.Printf("Got reply: %v", reply)
}

func (grpc grpcClient) RouteChat() {
	notes := []*pb.RouteNote{
		&pb.RouteNote{
			Location: &pb.Point{
				Latitude:  1000,
				Longitude: 1000,
			},
			Message: "hello world",
		},
		&pb.RouteNote{
			Location: &pb.Point{
				Latitude:  1000,
				Longitude: 1000,
			},
			Message: "hello world 2",
		},
	}
	stream, err := grpc.client.RouteChat(context.Background())
	if err != nil {
		log.Fatal(err)
	}
	waitc := make(chan struct{})
	go func() {
		for {
			in, err := stream.Recv()
			if err == io.EOF {
				close(waitc)
				return
			}
			if err != nil {
				log.Fatalf("Failed to receive note:%v", err)
			}
			log.Printf("Got message %v", in)
		}
	}()

	for _, note := range notes {
		if err := stream.Send(note); err != nil {
			log.Fatal(err)
		}
	}
	stream.CloseSend()
	<-waitc
}

func main() {
	conn, err := grpc.Dial(":55001", grpc.WithInsecure())
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close()

	// client := pb.NewRouteGuideClient(conn)

	client := grpcClient{
		client: pb.NewRouteGuideClient(conn),
	}

	// client.GetFeature()
	// client.ListFeatures()
	// client.RecordRoute()
	client.RouteChat()

}
