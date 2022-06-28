#!/bin/bash
export PATH=$PATH:/usr/local/go/bin:/root/go/bin
echo "PATH=$PATH:/usr/local/go/bin:/root/go/bin" >> /root/.bashrc

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

bom_python() {
  pip3 install -q -r requirements.txt
  /usr/local/bin/pip-licenses -f json | jq '.[]' > bom.formated.json
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
  bom_python
elif [ -e conanfile.txt ]; then
  bom_conan
else
  echo "Error: Could not auto detect the project type"
  exit 1
fi

cat ./bom.formated.json \
  | jq '{Name,Version,License,"Check": (if (.License | test("^AGPL|^CC-BY-NC|Commons-Clause|^Facebook|WTFPL")) then "Forbidden" else "OK" end)}' \
  | jq -s 'sort_by(.Check, .License, .Name)' \
  | jtbl

rm bom.formated.json
exit 0
