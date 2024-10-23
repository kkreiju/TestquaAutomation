<p align="center">
  <img src="assets/oshawott.png" alt="Oshawott" height=200>
</p>

<h1 align="center"> IT-TESTQUA31 Final Project </h1>
<p align="center"><i >Updated as of October 24, 2024.</i></p><br>
Robotic Process Automation of ELDNET 1 Final Project.

## Tech Stack
- <i>Python 3.11<br>
- Robot Framework</i>

## Members
**Arjay Nino Saguisa**<br>
**John Reddick Quijano**<br>
**Blaise Lorenz Bernabe**<br>
**Kricel Alvarado**

## Instructions

- **Use PyCharm or Visual Studio Code**

- **Set Up Virtual Environment**
```powershell
python -m venv .venv
.\.venv\Scripts\activate
```
*If activate.ps1 will not execute run this command as administrator*
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

- **Install Robot Framework Dependencies**
```powershell
pip install robotframework robotframework-browser robotframework-requests robotframework-seleniumlibrary
```

- **Install Pip Dependency Tree (optional)**
```powershell
pip install pipdeptree
```
- **Intall RCC**
```powershell
curl -o rcc.exe https://downloads.robocorp.com/rcc/releases/latest/windows64/rcc.exe
```
- **Run Robot Framework File**
```powershell
cd TestquaAutomation
..\rcc.exe run -t "TESTQUA"
```

<hr>

- **For Visual Studio Code**

*Configure Python Language Server in Robot Framework Language Server Extension to ensure site packages are loaded*

<p align="center">
  <img src="assets/instruction.png" alt="instruction">
</p>

```
${workspaceFolder}\.venv\Lib\site-packages
```