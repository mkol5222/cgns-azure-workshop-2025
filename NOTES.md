

# obtain Azure service principal credentials for automation

- open https://shell.azure.com/ in bash
- review `curl -sL https://run.klaud.online/make-sp.sh`
- and create new SP using `source <(curl -sL https://run.klaud.online/make-sp.sh)`
- copy the output to `sp-credentials.json`
- copy encryoted SP similar to `export SP="U2FsdGVkX198...9hEqZXNZGE="` to Codespace terminal
- retrieve credentials for automation with `make get-sp` which results to `sp.json` and `reader.json`
- check if SP is valid using `make check-sp`
- start Security Management server deployment with `make cpman`
- monitor progress with `make cpman-serial`
- check Management API readiness to login from SmartConsole - `make check-cpman`
- once magememnt API is ready, policy can be deployed with `make policy`