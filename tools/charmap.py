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
        text.insert(3,',')
        text.insert(4,'$')
    return ''.join(text)

def replaceText(text,dictionary):
    result = ''
    for i in range(len(text)):
        char = text[i]
        if char in dictionary:
            ending = ','
            if i == len(text) - 1:
                ending = ''
            result += dictionary[char]+ending
        else:
            print('Code Table Not Found!')
    return result + ' ; ' + text

def readCharMaps():
    result = {}
    lines = readTextLines('charmap.txt')
    for line in lines:
        text = removeReturn(line)
        components = text.split('=')
        if len(components) > 1:
            result[components[0]] = handleTwoBytes(components[1])
    return result