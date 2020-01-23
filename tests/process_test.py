import subprocess



p = subprocess.Popen(["apt-get", "update"], stdout=subprocess.PIPE, stdin=subprocess.PIPE)
stdout, stderr = p.communicate()
print stdout


'''
    if p.returncode != 0:
        print p.stderr.read().strip()
    else:
        print ''.join(out).strip()
'''
