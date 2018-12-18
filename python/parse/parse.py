import sys 
filename = sys.argv[1]
input = open(filename).readlines()
output = open("parse/parsed.python","w")

indent = []
for line in input:
    new_indent = len(line) - len(line.lstrip())
    new_line = ""
    if not line.strip() or line[:6] == "import" or  line[:4]=="from" or line.strip()[0]=='#':
        new_line = ""
    elif line.strip() and line.strip()[-1] == ':':
        if indent and new_indent <= indent[-1]:
            new_line = " "*indent[-1] + "} \n"
            indent.pop()
            while indent and indent[-1]>=new_indent:
                new_line += " "*indent[-1] + "} \n" 
                indent.pop()
            new_line +=  line.split(':')[0] + " {" + " \n" 
        else:
            new_line = line.split(':')[0] + " {" + " \n"
        indent.append(new_indent)

    elif indent and new_indent <= indent[-1]:
        new_line = " "*indent[-1] + "} \n"
        indent.pop()
        while indent and indent[-1]>=new_indent:
            new_line += " "*indent[-1] + "} \n"
            indent.pop()
        if not line.strip().endswith(";"):
            new_line += line.strip() + " ;" + " \n"
        else:
            new_line += line.strip() + " \n"
    else:
        if not line.strip().endswith(";"):
            new_line += line.strip() + " ;" + " \n"
        else:
            new_line += line.strip() + " \n"
    if "#" in new_line:
        new_line = new_line[new_line.index("#")]+"\n"
    output.write(new_line)

while indent:
  output.write(" "*indent.pop() + "}"+"\n")

output.close()