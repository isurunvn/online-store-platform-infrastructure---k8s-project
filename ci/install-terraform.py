#!/usr/bin/env python3
import hashlib,io,os,pathlib,urllib.request,zipfile
data=urllib.request.urlopen('https://releases.hashicorp.com/terraform/1.14.0/terraform_1.14.0_linux_amd64.zip',timeout=120).read()
assert hashlib.sha256(data).hexdigest()=='33ac217458ba8b44ce2813553083bc132c9a07e41a79c2e3627977682d283093', 'Terraform checksum mismatch'
dest=pathlib.Path(os.environ.get('RUNNER_TEMP','/tmp'))/'online-store-ci-bin';dest.mkdir(exist_ok=True)
with zipfile.ZipFile(io.BytesIO(data)) as z:(dest/'terraform').write_bytes(z.read('terraform'))
(dest/'terraform').chmod(0o755)
with open(os.environ['GITHUB_PATH'],'a') as f:f.write(str(dest)+'\n')
