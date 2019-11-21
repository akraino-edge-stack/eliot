/*
Package cmd
Copyright © 2019 NAME HERE <EMAIL ADDRESS>

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

package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
	"github.com/spf13/pflag"
	types "elcli/cmd/common"
	"elcli/cmd/util"
)

var joinOptions = &types.JoinOptions{}

// joinCmd represents the join command
var joinCmd = &cobra.Command{
	Use:   "join",
	Short: "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
	and usage of using your command. For example:
	
	Cobra is a CLI library for Go that empowers applications.
	This application is a tool to generate the needed files
	to quickly create a Cobra application.`,

	RunE: func(cmd *cobra.Command, args []string) error {
		fmt.Println("join called")

		tools := make(map[string]types.ToolsInstaller, 0)
		flagVals := make(map[string]types.FlagData, 0)

		checkFlags := func(f *pflag.Flag) {
			util.AddToolVals(f, flagVals)
		}
		cmd.Flags().VisitAll(checkFlags)

		//joinOptions := &types.JoinOptions{}
		joinOptions = newJoinOptions()

		Add2ToolsList(tools, flagVals, joinOptions)
		return ExecuteTool(tools)

	},
}

func init() {
		
	// Join Command added as sub-command for main command : elcli
	rootCmd.AddCommand(joinCmd)

	joinCmd.Flags().StringVar(&joinOptions.DockerVersion, types.DockerVersion, joinOptions.DockerVersion,
		"Use this key to download and use the required Docker version")
	joinCmd.Flags().Lookup(types.DockerVersion).NoOptDefVal = joinOptions.DockerVersion

	joinCmd.Flags().StringVar(&joinOptions.KubernetesVersion, types.KubernetesVersion, joinOptions.KubernetesVersion,
		"Use this key to download and use the required Kubernetes version")
	joinCmd.Flags().Lookup(types.KubernetesVersion).NoOptDefVal = joinOptions.KubernetesVersion

	joinCmd.Flags().StringVar(&joinOptions.K8SImageRepository, types.K8SImageRepository, joinOptions.K8SImageRepository,
		"Use this key to set the Kubernetes docker image repository")
	joinCmd.Flags().Lookup(types.K8SImageRepository).NoOptDefVal = joinOptions.K8SImageRepository

}


func newJoinOptions() *types.JoinOptions {
	fmt.Println("Inside newJointOptions Method.....")
	opts := &types.JoinOptions{}
	opts.InitOptions = types.InitOptions{DockerVersion: types.DefaultDockerVersion, KubernetesVersion: types.DefaultK8SVersion}
	//opts.CertPath = types.DefaultCertPath
	return opts
}


//Add2ToolsList Reads the flagData (containing val and default val) and join options to fill the list of tools.
func Add2ToolsList(toolList map[string]types.ToolsInstaller, flagData map[string]types.FlagData, joinOptions *types.JoinOptions) {

	var k8sVer, dockerVer string
	/*var k8sImageRepo string

	flgData, ok := flagData[types.K8SImageRepository]
	if ok {
		k8sImageRepo = util.CheckIfAvailable(flgData.Val.(string), flgData.DefVal.(string))
	} else {
		k8sImageRepo = joinOptions.K8SImageRepository
	}

	*/

	//toolList["EliotEdge"] = &util.KubeEdgeInstTool{Common: util.Common{ToolVersion: kubeVer}, K8SApiServerIP: joinOptions.K8SAPIServerIPPort,
	//	CloudCoreIP: joinOptions.CloudCoreIP, EdgeNodeID: joinOptions.EdgeNodeID}

	flgData, ok := flagData[types.DockerVersion]
	if ok {
		dockerVer = util.CheckIfAvailable(flgData.Val.(string), flgData.DefVal.(string))
	} else {
		dockerVer = joinOptions.DockerVersion
	}
	toolList["Docker"] = &util.DockerInstTool{Common: util.Common{ToolVersion: dockerVer}, DefaultToolVer: flgData.DefVal.(string)}

	
	flgData, ok = flagData[types.KubernetesVersion]
	if ok {
		k8sVer = util.CheckIfAvailable(flgData.Val.(string), flgData.DefVal.(string))
	} else {
		k8sVer = joinOptions.KubernetesVersion
	}
	toolList["Kubernetes"] = &util.K8SInstTool{Common: util.Common{ToolVersion: k8sVer}, IsEdgeNode: false, DefaultToolVer: flgData.DefVal.(string)}


}

//ExecuteTool the instalation for each tool and start edgecore
func ExecuteTool(toolList map[string]types.ToolsInstaller) error {

	//Install all the required pre-requisite tools
	for name, tool := range toolList {
		if name != "EliotEdge" {
			err := tool.InstallTools()
			if err != nil {
				return err
			}
		}
	}

	//Install and Start ElioteEdge Node
	return toolList["ElioteEdge"].InstallTools()
}