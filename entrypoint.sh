#!/bin/bash
export PATH=$PATH:/usr/local/go/bin:/root/go/bin:/root/.local/bin
echo "PATH=$PATH:/usr/local/go/bin:/root/go/bin:/root/.local/bin" >> /root/.bashrc

cd /code

bom_go() {
  cyclonedx-gomod mod -json -licenses \
    | jq .components \
    | jq '.[]|{"Name":.name,"Version":.version,"License":(.evidence.licenses[0].license.id // "Unknown")}' > bom.formated.json
}

bom_node() {
  cyclonedx-node -o bom.json
  cat ./bom.json \
    | jq .components \
    | jq '.[]|{"Name":.name,"Version":.version,"License":(.licenses[0].license.id // "Unknown")}' > bom.formated.json
  rm bom.json
}

bom_python_pipfile() {
  /root/.local/bin/pipenv lock -r > requirements.txt  
}

bom_python_requirements() {
  virtualenv bom-venv > /dev/null 2>&1
  . bom-venv/bin/activate
  pip3 install -q -r requirements.txt > /dev/null 2>&1
  pip3 install pip-licenses > /dev/null 2>&1
  pip-licenses -f json | jq '.[]' > bom.formated.json
  rm -rf ./bom-venv
}

bom_conan() {
  if [ -e remotes.txt ]; then
    conan config install remotes.txt > /dev/null 2>&1
  fi
  conan install . > /dev/null 2>&1
  conan info . -j | jq '.[]|{"Name":.reference | split("/")[0],"Version": .reference | split("/")[1],"License":(.license[0] // "Unknown")}' > bom.formated.json
}

if [ -e go.mod ]; then
  bom_go
elif [ -e package.json ]; then
  bom_node
elif [ -e requirements.txt ]; then
  bom_python_requirements
elif [ -e Pipfile ]; then
  bom_python_pipfile
  bom_python_requirements
elif [ -e conanfile.txt ]; then
  bom_conan
else
  echo "Error: Could not auto detect the project type"
  exit 1
fi

cat ./bom.formated.json \
  | jq '{Name,Version,License,"Check": (if (.License | test("^AGPL|^CC-BY-NC|Commons-Clause|^Facebook|WTFPL")) then "Forbidden" else "OK" end)}' \
  | jq -s 'sort_by(.Check, .License, .Name)' > ./bom.validated.json
rm ./bom.formated.json

case $FORMAT in
  csv)
    cat ./bom.validated.json | dasel -r json -w csv
    ;;
  json)
    cat ./bom.validated.json | jq
    ;;
  table)
    cat ./bom.validated.json | jtbl
    ;;
  *)
    cat ./bom.validated.json | jtbl
    ;;
esac

rm ./bom.validated.json
exit 0
