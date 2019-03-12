#!/bin/bash

# Create the gitblit_properties dictionary in declare_properties_dictionary.sh
source declare_properties_dictionary.sh

GITBLIT_PROPERTIES_FILE=/opt/gitblit-data/gitblit.properties

function set_gitblit_property {
  local env_var_name=$1

  # check env in dictionary
  if [ "${gitblit_properties[$env_var_name]}" ]; then
    local env_var_value=${!env_var_name} 
    local gitblit_property=${gitblit_properties[$env_var_name]}

    echo "Found '$env_var_name' do setting property '$gitblit_property' to value '${env_var_value} in file $GITBLIT_PROPERTIES_FILE"
    if [ "$(grep "${gitblit_property}=${env_var_value}" $GITBLIT_PROPERTIES_FILE | wc -l)" -eq "0" ]; then
       if [ "$(grep "${gitblit_property}" $GITBLIT_PROPERTIES_FILE | wc -l)" -ne "0" ]; then
          gitblit_property_search=${gitblit_property/\./\\\.}
          sed -i /$gitblit_property_search/d $GITBLIT_PROPERTIES_FILE
       fi
       echo "${gitblit_property}=${env_var_value}" >> $GITBLIT_PROPERTIES_FILE
    fi
  else
    echo "No property exists with name $env_var_name"
  fi
}

echo "Finding GITBLIT_* env vars and setting them as properties"
# Get the env vars and pass to set_gitblit_property to process
for env_var in $(env | grep  "^GITBLIT_" | cut -d= -f1); do
  set_gitblit_property $env_var
done

echo "Running Gitblit server... "
java -server -Xmx1024M -Djava.awt.headless=true -jar /opt/gitblit/gitblit.jar --baseFolder /opt/gitblit-data
