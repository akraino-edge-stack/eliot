/*
Copyright 2019 The ELIOT Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package common

const (
	//DefaultDockerVersion is the current default version of Docker
	DefaultDockerVersion = "18.06.0"

	//DefaultK8SVersion is the current default version of K8S
	DefaultK8SVersion = "1.14.1"

	// K8SImageRepository sets the image repository of Kubernetes
	K8SImageRepository = "image-repository"

	//K8SPodNetworkCidr sets pod network cidr of Kubernetes
	K8SPodNetworkCidr = "pod-network-cidr"

	//DockerVersion sets the version of Docker to be used
	DockerVersion = "docker-version"

	//KubernetesVersion sets the version of Kuberneted to be used
	KubernetesVersion = "kubernetes-version"

	//K8SAPIServerIPPort sets the IP:Port of Kubernetes api-server
	K8SAPIServerIPPort = "k8sserverip"

	//EliotCloudNodeIP sets the IP of KubeEdge cloud component
	EliotCloudNodeIP = "eliotcloudnodeip"

	//EliotEdgeNodeID Node unique idenfitcation string
	EliotEdgeNodeID = "eliotedgenodeid"	
)