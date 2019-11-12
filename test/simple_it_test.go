package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestIT_SimpleExample(t *testing.T) {
	if testing.Short() {
		t.Skip("skipping integration tests")
	}

	t.Parallel()

	tfOptions := &terraform.Options{
		TerraformDir: "../examples/simple",
	}

	defer terraform.Destroy(t, tfOptions)
	terraform.InitAndApply(t, tfOptions)
}
