/*
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
	"elcli/cmd/util"
)

var (

	elcliResetCmdLongDescription = `
+-----------------------------------------------------------+
|  To Reset the ELIOT Cluster.                              |
|                                                           |
+-----------------------------------------------------------+
| RESET: It will reset the setting and the kubernetes       | 
| cluster, underying softwares of ELIOT platform will not be|
| still installed.                                          |
+-----------------------------------------------------------+
`
)

// resetCmd represents the reset command
var resetCmd = &cobra.Command{
	Use:   "reset",
	Short: "Reset ELIOT Cluster!!",
	Long:   elcliResetCmdLongDescription,
	RunE: func(cmd *cobra.Command, args []string) error{
		fmt.Println("reset called")
		err := util.EliotReset()
		str:= util.GetOSVersion()
		if (err != nil){
			return err
		}
		fmt.Println("Print value of GetOSVersion", str)
		return nil
	},
}

func init() {
	rootCmd.AddCommand(resetCmd)
}
