from openpyxl import load_workbook
from openpyxl.styles import Color, PatternFill, Font, Border

import sys
import openpyxl
import shutil
import os



def readTextLines(path):
    file = open(path,"r")
    return file.readlines()

def removeNone(text):
    if text == None:
        return ''
    return text

def removeReturn(text):
    if text == None:
        return ''
    return text.replace('\n','')

def handleTwoBytes(code):
    text = list(code)
    if len(text) > 3:
        if text[0] != '"':
            text.insert(3,',') 
            text.insert(4,'$')
    return ''.join(text)

def replaceStr(text,dict):
    output = removeNone(text)
    for key in dict:
        output = output.replace(key,dict[key])
    return output

chsReplacement = {'ć':'<PLAYER>','č':'<RIVAL>','犇':'<USER>','骉':'<TARGET>'}
def replaceText(text,dictionary,mode):
    if mode == 2:
        output = replaceStr(text,chsReplacement)
        return '\"' + output + '\"' 
    else:
        result = ''
        for i in range(len(text)):
            char = text[i]
            if char in dictionary:
                ending = ','
                if i == len(text) - 1:
                    ending = ''
                result += dictionary[char]+ending
            else:
                ending = ','
                if i == len(text) - 1:
                    ending = ''
                result += '\"' + char + '\"' + ending
                if not char.lower() in 'abcdefghijklmnopqsrtuvwxyz!?,.:@ぁ0123456789/♀♂×#¥″ ':
                    print(text)
                    print(char + ' : Code Table Not Found!')
        newText = replaceStr(text,chsReplacement)
        return result + ' ; ' + newText

def readCharMaps():
    result = {}
    lines = readTextLines('charmap.txt')
    for line in lines:
        text = removeReturn(line)
        components = text.split('=')
        if len(components) > 1:
            result[components[0]] = handleTwoBytes(components[1])
    return result