#!/usr/bin/env python3
# Compatibility entry point retained for the original current source make target.
# the current source's semantic verifier reconstructs the now-structured db/dw source.
from pathlib import Path
import subprocess,sys
script=Path(__file__).with_name('verify_map_ai_tactical_selector_semantics.py')
rom=sys.argv[1] if len(sys.argv)>1 else 'baserom.gbc'
subprocess.check_call([sys.executable,str(script),rom])
print('[ok] current source tactical-selector compatibility check delegated to current source semantic verifier')
