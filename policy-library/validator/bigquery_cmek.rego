#
# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package templates.gcp.GCPBigQueryCMEKEncryptionConstraintV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	asset := input.asset
	asset.asset_type == "bigquery.googleapis.com/Table"

	# Find KMS key name for the table
	encryptionConfiguration := lib.get_default(asset.resource.data, "encryptionConfiguration", {})
	kmsKeyName := lib.get_default(encryptionConfiguration, "kmsKeyName", "NOTFOUND")

	# Check if KMS is enabled
	kmsKeyName == "NOTFOUND"

	message := sprintf("%v does not have the client managed encryption key setup.", [asset.name])
	metadata := {"resource": asset.name}
}
