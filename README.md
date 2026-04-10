# orchastrator
as orderly as a swiss watch
## an app trying to distill the means to human collaboration.
the app allows the creation of groups and the different methods of communicating in them,  
from a simple chat to a tally wager to a station tracker, on completion, this modular app should either have it,  
or make programming it easy 
currently adding new objectives requires recompiling as dynamic code loading is out of scope for a school project

## Features
1. customizability: custom widgets can be loaded at runtime and data can be shared across many devices
2. customizability: the server can be self-hosted everywhere and work the same way
3. also customizability: the app is open-source and any hard-to-fix problems (if they even exist considering #1) can be mitigated by making your own version  
I think you got the idea.  

this app aims to provide a canvas upon which every method of communicating can be created,  
users are registered in groups which are registered on servers(relays),  
all internal group communication is end-to-end encrypted via a shared key,  
and the users can communicate from custom widgets called objectives which are defined in the group by an admin.  
the app is responsible for transferring the data from the objective to the relay and the relay is responsible for distributing it.
