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
	"elcli/cmd/util"
)

var (
	elcliCleanCmdLongDescription =
	`
	+-------------------------------------------------+
	| To complete cleanup execute this command. The   |
	| command will remove all the configurations,     |
	| clear up ports used by ELIOT cluster & uninstall|
	| all software.                                   |
	+-------------------------------------------------|
	`
	elcliCleanExample = `
	+-------------------------------------------------+
	| elcli clean                                     |
	+-------------------------------------------------+
	`
)

// cleanCmd represents the clean command
var cleanCmd = &cobra.Command{
	Use:   "clean",
	Short: "ELIOT Cluster Uninstall",
	Long:  elcliCleanCmdLongDescription,
	Example: elcliCleanExample,
	RunE: func(cmd *cobra.Command, args []string) error{
		fmt.Println("clean called")
		err := util.EliotClean() 	
		str:= util.GetOSVersion()
		fmt.Println("Print value of GetOSVersion %s", str)

		if(err != nil) {
			return err
		}
		return nil		
	},
}

func init() {
	rootCmd.AddCommand(cleanCmd)
}
