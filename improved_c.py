import re
import sys

class Replacer:
    def __init__(self):
        self.replacements = []
        
    def add(self, str1, str2):
        self.replacements.append((str1, str2))
        
    def replace(self, line):
        replaced = True
        while replaced:
            replaced = False
            for repl in self.replacements:
                line, succeed = re.subn(repl[0], repl[1], line)
                if succeed > 0:
                    replaced = True
        return line

class FileData:
    def __init__(self):
        self.next_private = False
        self.next_public = False
        self.vars = False
        self.next_class = None
        self.type = None
        self.noh = False
        self.replacer = Replacer()
    
    def needs_processing(self):
        return self.next_class
        
    def remperms(self, line):
        if line[0] != ' ' and "{" not in line:
            self.next_private = False
            self.next_public = False
    
# c, h
def conv_to_ch(line, filedata):
    line = preprocess(line)
    if "##" in line:
        # for modifying functions only
        if "replace" in line:
            line = line[10:]
            strs = line.split("-->>")
            filedata.replacer.add(strs[0], strs[1])
        elif len(re.findall(r"<.*>", line)) > 0:
            cname = re.findall(r"<.*>", line)[0]
            filedata.next_class = cname[1:-1]
            if "func" in line:
                filedata.type = "func"
        # for files which will only need to be seen by the c file
        elif "include" in line:
            fname = re.findall(r"\".*\"", line)[0]
            fname = fname[1:-1]
            return ("#include \""+fname+".h\"", None)
        elif "requires" in line:
            fname = re.findall(r"\".*\"", line)[0]
            fname = fname[1:-1]
            return (None, "#include \""+fname+".h\"")
        elif "private" in line:
            filedata.next_private = True
        elif "public" in line:
            filedata.next_public = True
        elif "endvars" in line:
            filedata.vars = False
        elif "vars" in line:
            filedata.vars = True
        elif "noh" in line:
            filedata.noh = True
        return (None, None)
    else:
        if filedata.noh:
            return (line, None)
        if filedata.vars:
            return (line, "extern " + chopeq(line))
        if filedata.next_private:
            filedata.remperms(line)
            return (line, None)
        elif filedata.next_public:
            filedata.remperms(line)
            return (None, line)
        if "{" in line and not re.match("^  ", line):
            return (line, line[:-2] + ";")
        elif "{" in line or "}" in line or "include" in line or len(line.strip()) == 0 or re.match("^  ", line) != None:
            return (line, None)
        else:
            return (None, line)             
            
def preprocess(line):
    line = filedata.replacer.replace(line)
    if filedata.next_class != None and "##" not in line and len(line) > 3:
        ftype = line.split()[0]
        fname = re.findall(r"[\w\d]+", line)[1]
        fparams = re.findall(r"\(.*\)", line)[0][1:-1]
        fbegin = ftype + " " + fname + "__" + filedata.next_class + "("
        if filedata.type == "func":
            fbegin += filedata.next_class + "* self"
            if len(fparams) > 0:
                fbegin += ", "
        fbegin += fparams + ") {"
        filedata.type = None
        filedata.next_class = None
        return fbegin
    return line
    
def remn(line):
    if line[-1] == '\n':
        return line[:-1]
    return line

def chopeq(line):
    strs = line.split("=")
    if len(strs) != 2:
        return line
    return strs[0][:-1] + ";"

filename = sys.argv[1]
srcdir_path = sys.argv[2]
todir_path = sys.argv[3]

h_file = re.sub(r"\.[^\.]*$", ".h", filename)
c_file = re.sub(r"\.[^\.]*$", ".c", filename)

h_path = todir_path+"/"+h_file
c_path = todir_path+"/"+c_file

with open(srcdir_path+"/"+filename) as f:
    h = open(h_path, "w+")
    c = open(c_path, "w+")
    # write necessary data
    h.write("#ifndef __" + h_file.replace(".", "_") + "__\n")
    h.write("#define __" + h_file.replace(".", "_") + "__\n")
    c.write("#include \"" + h_file + "\"\n")
    filedata = FileData()
    while line := f.readline():
        line = remn(line)
        c_line, h_line = conv_to_ch(line, filedata)
        if c_line != None:
            c.write(c_line + "\n")
        if h_line != None:
            h.write(h_line + "\n")
    h.write("#endif")
    h.close()
    c.close()
