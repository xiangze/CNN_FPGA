from jinja2 import Environment, FileSystemLoader
env = Environment(loader=FileSystemLoader('./', encoding='utf8'))

def frender(fname,d):
    templ = env.get_template(fname)
    return templ.render(d)

def fwrite(f,fname):
    with open(fname,"w") as fw:
        fw.write(f.encode('utf-8'))

def renderfromfile(tempname,d,outfname):
    fwrite(frender(tempname,d) ,outfname)
        
width=10
fn=range(3)

lnum=7
nt=[32,32,64,64,128,128]
nn1s=[1]+nt
nn2s=nt+[1]

n1s=[]
n2s=[]
for l in xrange(lnum):
    n=nn1s[l]
    m=nn2s[l]
    print l,n,m

    n1=range(n)
    n2=range(m)
    
    n1s.append(n1)
    n2s.append(n2)
    d={'width':width,'fn':fn,'nn1':n, 'nn2':m, 'n1':n1, 'n2':n2}
    
    renderfromfile(frender("template/filter_n1.v",d) ,"filter_n1_%d.v"%n)
    renderfromfile(frender("template/filter_n2.v",d) ,"filter_n2_%d.v"%m)
    renderfromfile(frender("template/filter_line_n2.v",d) ,"filter_n2_line_%d.v"%m)


d={'width':width,'fn':fn,'n1':n1s,'n2':n2s,'ls':range(lnum),'lnum':lnum}
renderfromfile(frender("template/filter_l.v",d) ,"filter_l_%d.v"%lnum)