

# cd /harness
if [[ -f "apgxEnvConfig.yaml" ]]; then
  echo "apgxEnvConfig.yaml file found, using it to set up environment variables"
  env_det=$(yq e '.envs[] | .apigeeOrgName' "apgxEnvConfig.yaml" | while read -r org; do
  if [[ "$org" == dmz-apgi* ]]; then
    echo "internal"
  elif [[ "$org" == dmz-apge* ]]; then
    echo "external"
  else
    echo "unknown"
  fi
done)
#   echo "$env_det"
  apigee_instance=$(echo "$env_det" | sort -u | tr '\n' ',' | sed 's/,$//')

else
 echo "apgxEnvConfig.yaml file not found,Looking for extenral and internal env files"
 apigee_instance=""
 if [[ -f "apgxEnvConfigApgi.yaml" ]]; then
    apigee_instance="internal"
  fi
 if [[ -f "apgxEnvConfigApge.yaml" ]]; then
    if [[ -z "$apigee_instance" ]]; then
      apigee_instance="external"
    else
      apigee_instance="${apigee_instance},external"
    fi
 fi
fi
echo "$apigee_instance"
export apigee_instance