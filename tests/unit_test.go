// https://github.com/cloudposse/terraform-aws-ecs-alb-service-task/blob/master/test/src/examples_complete_test.go
//
// NOTE:
// issue is open for reordering vars and var-file: https://github.com/gruntwork-io/terratest/pull/256
//

package test

import (
	"fmt"
	"testing"
	"os"

	"github.com/gruntwork-io/terratest/modules/aws"
// 	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"

	awsSDK "github.com/aws/aws-sdk-go/aws"
	"github.com/stretchr/testify/assert"
)

// Test the Terraform module: ecs using Terratest.
func TestTerraformAwsEcs(t *testing.T) {
	t.Parallel()
    // ----------------------------------------------------------
	// Path to Terraform code
	TF_REPO_PATH            := "../example/ecs/base"
	// ----------------------------------------------------------
	// Path to test variable file
	TF_VARS_FILE_PATH       := "../test_data/test.tfvars"
    // ----------------------------------------------------------
	// remote state variables
	// ----------------------------------------------------------
    remoteStateBucketName   := os.Getenv("TF_AWS_BUCKET")
    remoteStateBucketKey    := "test"
    awsBucketRegion         := "us-west-2"
    // ----------------------------------------------------------
    // expected results
    // ----------------------------------------------------------
	expectedTeamName        := fmt.Sprintf("rumse")
	expectedProjectName     := fmt.Sprintf("demo-ecs-test") //-%s", random.UniqueId())
	ecsName                 := fmt.Sprintf("rumse-demo-ecs-test")
	ecsServiceName          := ecsName + "-service"
	INSTANCE_TYPE           := "EC2" // other option is Fargate
    // ----------------------------------------------------------
    //
	// Pick a random AWS region to test in. This helps ensure your code works in all regions.
	// NOTE: pending update to _base_module
	//
	awsRegion := aws.GetRandomStableRegion(t, []string{"us-west-2"}, nil)

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: TF_REPO_PATH,

		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{TF_VARS_FILE_PATH},

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"teamid": expectedTeamName,
			"prjid": expectedProjectName,
		},
		BackendConfig: map[string]interface{}{
			"bucket": remoteStateBucketName,
			"key":    remoteStateBucketKey,
			"region": awsBucketRegion,
		},

		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,

		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Look up the ECS cluster by name
	cluster := aws.GetEcsCluster(t, awsRegion, ecsName)

	assert.Equal(t, int64(1), awsSDK.Int64Value(cluster.ActiveServicesCount))

	// Look up the ECS service by name
	service := aws.GetEcsService(t, awsRegion, ecsName, ecsServiceName)

	assert.Equal(t, int64(1), awsSDK.Int64Value(service.DesiredCount))
	assert.Equal(t, INSTANCE_TYPE, awsSDK.StringValue(service.LaunchType))
}