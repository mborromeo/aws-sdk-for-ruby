# Copyright 2011 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You
# may not use this file except in compliance with the License. A copy of
# the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
# ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require 'bundler/setup'
Bundler.require(:default, :build, :integration)

tasks_dir = File.join(File.dirname(__FILE__), "tasks")
$:.unshift(tasks_dir)
Dir[File.join(tasks_dir, "**", "*.rake")].each do |task_file|
  load task_file
end