from jinja2 import Environment, FileSystemLoader
env = Environment(loader=FileSystemLoader('./', encoding='utf8'))

def frender(fname,d):
    templ = env.get_template(fname)
    return templ.render(d)

def fwrite(f,fname):
    with open(fname,"w") as fw:
        fw.write(f.encode('utf-8'))


width=10
fn=range(3)

lnum=7
nt=[32,32,64,64,128,128]
n1=[1]+nt
n2=nt+[1]
print len(n1)
print n1
for l in xrange(lnum):
    n=n1[l]
    m=n2[l]
    
    n1=range(n)
    n2=range(m)
    f=frender("template/filter_n1.v",{'width':width,'fn':fn,'nn1':n,'n1':n1})
    fwrite(f,"filter_n1_%d.v"%n)

    f=frender("template/filter_n2.v",{'width':width,'fn':fn,'nn2':m,'n1':n1, 'n2':n2})
    fwrite(f,"filter_n2_%d.v"%m)

f=frender("template/filter_l.v",{'width':width,'fn':fn,'nn1':n,'nn2':m,'n1':n1,'n2':n2})
fwrite(f,"filter_l_%d.v"%lnum)
