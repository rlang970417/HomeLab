Step 1: Create the Environment
Open Command Prompt or PowerShell, navigate to your project folder, and run:

python -m venv .venv

.venv: This is the name of the folder that will be created. You can name it whatever you like, but .venv is the standard convention.

Step 2: Activate the Environment
You must "activate" the environment so that your terminal knows to use the local Python inside that folder instead of the system one.

For Command Prompt:

DOS

.venv\Scripts\activate
For PowerShell:

PowerShell

.\.venv\Scripts\Activate.ps1
Note for PowerShell Users: If you get a "scripts are disabled" error, run this command once to allow them:

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

Once activated, you will see (.venv) appear in parentheses at the start of your command line prompt.

Step 3: Use and Deactivate
While the environment is active, any pip install commands will stay inside that folder.

To install a package: pip install requests

To exit the environment: Simply type deactivate.


Step 4: Install our needed libraries
 
pip install wheel
pip install pyodbc
pip install prettyprint
pip install pyinputplus
pip install configparser
pip install sqlalchemy
pip install ipython-sql
pip install ipython_genutils
pip install pandas
pip install matplotlib
pip install jupyter


Step 5: Generate our requirements file

pip freeze > requirements.txt


Optional : Step 6: Install libraries from our requirements file

pip install -r requirements.txt