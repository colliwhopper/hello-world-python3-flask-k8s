
# general info

This is a python based "eks-test-app" app, running in flask.

 **prereqs**  
working local installation of minikube   
local host admin access  

**docker scan results (15/06/22)**  
Package manager:   deb  
Project name:      docker-image|hello_world  
Docker image:      hello_world  
Platform:          linux/arm64

Tested 96 dependencies for known vulnerabilities, found 81 vulnerabilities.  

**docker image size**  
approx 154Mb  

# usage 

### local build and testing - docker

**build**  
```docker build -t eks-test-app:1.1 .```  
</br>

**check image**  
```docker images```  
</br>

**test locally in docker**  
```docker run -d --rm -p 8080:8080 eks-test-app:1.1```  
```docker ps -a```    
```curl -i -w '\n' http://localhost:8080```  
</br>

**stop and remove all local docker containers before minikube deployment**  
```docker stop $(docker ps -a -q)``` * \
```docker rm $(docker ps -a -q)``` * \
```docker ps -a```  

&ast; be careful the above commands stop and remove ALL local docker containers.  
</br>
### local deployment - minikube

**start minikube**  
```minikube start```  
</br>

**set up minikube tunnel**  
```minikube tunnel``` *  

&ast; Note - the minikube tunnel command is required to be able to access the hello-world service ip endpoint outside of the minikube cluster.  

&ast; Note - the minikube tunnel command needs to be from a separate dedicated terminal session, as the tunnel command needs to remain in the foreground to function.  
</br>

**make hello-world image available to minikube**  
```minikube image load hello-world:1.0```  
</br>

**deploy "hello-world" deployment and service to minikube**  
```kubectl create -f hello-world-k8s.yaml```  
</br>

**check running**   
```kubectl get pods -n default```  
```kubectl describe pod <podname> -n default```  

```kubectl logs svc/hello-world -n default```  

```kubectl describe deployment hello-world -n default```  
```kubectl describe svc hello-world -n default```

then navigate to http://127.0.0.1:8080 and check "hello-world :P" message exists.  
</br>
you can also curl this message from within one of the pod containers:  

```kubectl get pods```  
```kubectl exec -it <pod name> /bin/sh```  
```curl -i http://hello-world.default.svc.cluster.local:8080``` (from within container)  

&ast; curl can be removed from the Dockerfile if this functionality is not required, it reduces the image size approx 4Mb.  
</br>

**to update hello-world service image** \
develop and test a new image in docker then, using "new" image "hello-world:1.1" as an example:

```minikube image load hello-world:1.1```  
```kubectl set image deployment/hello-world hello-world=hello-world:1.1```  
```kubectl get all``` - to monitor rollout

# cleanup 
```kubectl delete service hello-world```  
```kubectl delete deployment hello-world``` \
``kubectl get all``

```minikube stop --all```  
```minikube status``` - to check minikube has stopped 
