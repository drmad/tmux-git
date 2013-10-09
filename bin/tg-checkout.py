#!/usr/bin/env python3
# tmux-git
# Script for showing current Git branch in Tmux status bar
#
# Coded by Oliver Etchebarne - http://drmad.org/
#
# Helper script for checkout in another branch.
#
import curses, os, subprocess, sys

class tg_branches:
    mx = my = 0
    S = 0
    repo = ''
    branches = []
    active_branch= '';
    ab_id = 0;

    def center ( self, y, text, status = -1, fill = False ):
        cx = int(self.mx / 2 - len(text)/2)
        
        if fill:
            string = " " * cx
            string += text
            string += " " * (self.mx - len(string))
            
            text = string
            cx = 0
            
        
        self.S.addstr ( y, cx, text, status )

    def redraw(self):
        y = 2

        for id in range(len(self.branches)):
            branch = self.branches[id]
            
            if id == self.ab_id:
                attr = curses.color_pair(2)
            else:
                attr = curses.color_pair(1)
                
            self.center (y, branch, attr, fill = True)
            
            y += 1
            id += 1

    def main(self, S):

        curses.use_default_colors()
        
        # Normal
        curses.init_pair(1, curses.COLOR_WHITE, -1)
        # Selected
        curses.init_pair(2, curses.COLOR_RED, curses.COLOR_WHITE)
    
        self.S = S
        self.my, self.mx = self.S.getmaxyx()
        #self.S.border(0)
        
        # Titulo de la ventana
        title = "Branches in {}".format ( self.repo )
        if len(title) > 30:
            # Versión reducida
            title = "{}".format ( self.repo )
            
        self.center (0, title, curses.A_BOLD)

        # Dibujamos
        self.redraw()
        
        # Dibujamos las ramas
        char = ''
        while True:
            char = self.S.getch()

            # Convertimos todo a minúsculas
            if char >= 64 and char <= 90:
                char += 32
            
            redraw = False
            if char == curses.KEY_DOWN or char == ord("8"):
                self.ab_id += 1
                if self.ab_id >= len(self.branches):
                    self.ab_id = 0
                redraw = True
            elif char == curses.KEY_UP or char == ord("2"):
                self.ab_id -= 1
                if self.ab_id < 0:
                    self.ab_id = len(self.branches) - 1 
                redraw = True
            elif char == curses.KEY_ENTER or char == 10:
                # git checkout time!
                branch = self.branches[self.ab_id]
                subprocess.call (['git', 'checkout', branch])
                break;
            elif char == ord('q'):
                break
            elif char >= ord('a') and char <= ord('z'):
                # Buscamos.
                ss = self.ab_id
                while True:
                    ss +=1
                    if ss >= len(self.branches):
                        ss = 0
                       
                    if ord(self.branches[ss].lower()[0]) == char:
                        self.ab_id = ss
                        redraw = True
                        break
                        
                    if ss == self.ab_id:
                        break
            else:
                print (char)
                
            if redraw:
                self.redraw()                           


if __name__ == '__main__':
    tgb = tg_branches()
    
    # El 1er parámetro es la ruta del repo
    repodir = sys.argv[1]
    os.chdir ( repodir )


    tgb.repo = os.path.basename ( repodir )# os.path.basename ( os.environ["GIT_REPO"] )
    
    # Obtenemos las branches
    branches = subprocess.check_output(['git', 'branch'], universal_newlines=True).split("\n")
    
    # Parseamos
    active_branch = ''
    
    id = 0
    for branch in branches:
        branch = branch.strip()
        if not branch:
            continue
            
        if branch[0] == "*":
            branch = branch[2:]
            tgb.active_branch = branch
            tgb.ab_id = id

        tgb.branches.append ( branch )
        id += 1

    curses.wrapper(tgb.main)
