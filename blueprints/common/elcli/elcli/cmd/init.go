// 
// Copyright © 2019 NAME HERE <EMAIL ADDRESS>
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package cmd

import (
	"fmt"
	

	"github.com/spf13/cobra"

	"elcli/cmd/util"
)

var (
elcliSetupCmdDescription = 
`
ELIOT init command is for setting up the ELIOT Cluster. 
The command has options to setup the complete setup which includes
ELIOT Manager and ELIOT Edge Nodes and to setup only ELIOT Manager
or ELIOT Edge Node. The command invokes setup.sh script which handles
the complete setup.

The Details of ELIOT Edge Nodes must be present in [nodelist] file.
`
)
// initCmd represents the init command
var initCmd = &cobra.Command{
	Use:   "init",
	Short: "Setup ELIOT Cluster !!",
	Long:  elcliSetupCmdDescription,
	//It will check if the kubernetes process is already running on the node. 
	//Abort the operation if already running.
	PreRunE: func(cmd *cobra.Command,args []string) error {
		isELIOTClusterRunning, err := util.IsK8SClusterRunning()
		if err != nil {
			return err
		} else if (isELIOTClusterRunning) {
			return fmt.Errorf("Kubernetes Cluster is running in the Node. Clean up the environment and then setup the Cluster")
		}
		return nil
	},
	RunE: func(cmd *cobra.Command, args []string) error{
		fmt.Println("init called")
		setupFlag := cmd.Flag("setup")
		setupflagoption := setupFlag.Value.String()

		switch setupflagoption {
		case "all":
			err:= util.EliotSetupAll()
			return err
			fmt.Println("Inside all option for setup flag")
		case "master":
			fmt.Println("Its eliot setup Master")
			err:= util.EliotSetupMaster()
			return err
		default:
			fmt.Println("Provide option for flag [--setup :- all | master] or [-s :- all | master]")		
		}
		return nil
	},
}

func init() {
	rootCmd.AddCommand(initCmd)
	initCmd.Flags().StringP("setup","s","all","Eliot Topology setup options")

}
