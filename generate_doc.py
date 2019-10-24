#!/usr/bin/env python3
f = open('./command.sh', 'r')
line_list = []
content=''
for line in f.readlines():
    if line.startswith('#'):
        new_line = line[2:]
        if new_line.startswith('$'):
            line_list.append('* ' + new_line)
        else:
            line_list.append(new_line)
    elif line.strip().endswith('() {'): #strip for \n , fuck
        title='=== ' + line.split('(')[0] + '\n'
        new_list = []
        new_list.append(title)
        new_list.extend(line_list)
        print(''.join(new_list))
        line_list = []
