"""Generate native hosts without overwriting application source."""
from pathlib import Path
import shutil, subprocess, tempfile
root = Path(__file__).resolve().parents[1]
with tempfile.TemporaryDirectory(prefix='smart-study-') as directory:
    scaffold = Path(directory) / 'scaffold'
    subprocess.run(['flutter','create','--empty','--no-pub','--platforms=android,ios,windows,macos','--org=biz.canora','--project-name=smart_study_hub',str(scaffold)],check=True)
    for name in ['android','ios','windows','macos']:
        if not (root / name).exists(): shutil.copytree(scaffold / name, root / name)
    shutil.copy2(scaffold / '.metadata', root / '.metadata')
manifest = root / 'android/app/src/main/AndroidManifest.xml'
manifest.write_text(manifest.read_text().replace('android:label="smart_study_hub"','android:label="Smart Study Hub"'))
props = root / 'android/gradle.properties'
props.write_text(props.read_text().replace('-Xmx8G -XX:MaxMetaspaceSize=4G','-Xmx2G -XX:MaxMetaspaceSize=768m'))
wrapper = root / 'android/gradle/wrapper/gradle-wrapper.properties'
wrapper.write_text(wrapper.read_text().replace('gradle-8.12-all.zip','gradle-8.12-bin.zip'))
