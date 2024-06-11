
# general info
<hr/>

This is a python based "k8s-test-app" app, running in flask.

 **prereqs**  
working local installation of minikube   
local host admin access  

**docker scout v1.9.3 quickview results (11/06/24)**  
```Target │  local://k8s-test-app:1.1  │     0C     1H     0M    38L```

**docker image size**  
approx 160Mb  

# usage
<hr/>

### local build and testing - docker

**build**  
```docker build -t k8s-test-app:1.1 .```  
</br>

**check image**  
```docker images```  
</br>

**test locally in docker**  
```docker run -d --rm -p 8080:8080 k8s-test-app:1.1```  
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

&ast; Note - the minikube tunnel command is required to be able to access the k8s-test-app service ip endpoint outside the minikube cluster.  

&ast; Note - the minikube tunnel command needs to be from a separate dedicated terminal session, as the tunnel command needs to remain in the foreground to function.  
</br>

**make k8s-test-app image available to minikube**  
```minikube image load k8s-test-app:1.1```  
</br>

**deploy "k8s-test-app" deployment and service to minikube**  
```kubectl create -f k8s-test-app.yaml```  
</br>

**check running**   
```kubectl get pods -n default```  
```kubectl describe pod <podname> -n default```  

```kubectl logs svc/k8s-test-app -n default```  

```kubectl describe deployment k8s-test-app -n default```  
```kubectl describe svc k8s-test-app -n default```

then navigate to http://127.0.0.1:8080 and check "hello-world :P" message exists.  
</br>
you can also curl this message from within one of the pod containers:  

```kubectl get pods```  
```kubectl exec -it <pod name> /bin/sh```  
```curl -i http://k8s-test-app.default.svc.cluster.local:8080``` (from within container)  

&ast; curl can be removed from the Dockerfile if this functionality is not required, it reduces the image size approx 4Mb.  
</br>

**to update k8s-test-app service image** \
develop and test a new image in docker then, using "new" image "k8s-test-app:1.1" as an example:

```minikube image load k8s-test-app:1.1```  
```kubectl set image deployment/k8s-test-app k8s-test-app=k8s-test-app:1.1```  
```kubectl get all``` - to monitor rollout

**minikube cleanup** \
```kubectl delete service k8s-test-app```  
```kubectl delete deployment k8s-test-app``` \
``kubectl get all``

```minikube stop --all```  
```minikube status``` - to check minikube has stopped 

### remote deployment - dockerhub
```docker pull gabrielit/k8s-test-app:1.1```