import getpass
import os
print getpass.getuser()
print os.environ["USER"]
base_path = os.path.dirname(os.path.abspath(__file__))
print base_path