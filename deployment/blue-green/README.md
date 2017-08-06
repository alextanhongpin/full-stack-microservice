# blue-green (canary) deployment


A techinique that reduces downtime risk by running two identical production environment called Blue and Green.

E.g. You have Blue live.

You deploy Green, but it's idle and not serving any requests.

Both are deployed side-by-side.

After green has been tested and is ready, you switch your router so all incoming requests now go to Green instead of Blue.

Green is live. Blue is idle.

Advantage: Ensure a safe application rollout to production while minimizing downtime.


Frameworks/tools: Nomad, Linkerd, and Docker Swarm InfraKit.

Alternative: rolling upgrades
Other names:  Red/Black or A/B