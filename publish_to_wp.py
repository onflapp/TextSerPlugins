#!/usr/bin/env python
 
import xmlrpclib
import sys
import os
import mimetypes
import pprint
import re
import urlparse
import json
import hashlib
import codecs
 
#publish page user passwd http://localhost/wordpress/xmlrpc.php file

HOME = os.environ['HOME']

pp = pprint.PrettyPrinter(indent=4)
url = sys.argv[4]
user = sys.argv[2]
pw = sys.argv[3]
post_type = sys.argv[1]
title = 'new post'
slug = None
do_publish = False
 
REGISTRY_FILE = HOME+'/Library/Containers/com.onflapp.TextSer/Data/Library/Caches/com.onflapp.TextSer/'+re.sub(r'[:/]', '', url)+'_registry.json'

server = xmlrpclib.ServerProxy(url)

def log_DEBUG(log):
    print(log)

def display_result(postid):
    result = page_info(postid)
    print (result['link'])

def page_info(postid):
    result = server.wp.getPage(0, postid, user, pw)
    #pp.pprint(result)
    return result

def store_page(title, slug, body):
    content = {}
    content['title'] = title
    content['description'] = body
    content['post_type'] = 'page'

    if (slug != None): 
        content['wp_slug'] = slug

    postid = find_pageid(title)

    if (postid == None):
        result = server.metaWeblog.newPost(0, user, pw, content, do_publish)
        if (result != None):
            display_result(result)

    else:
        result = server.metaWeblog.editPost(postid, user, pw, content, do_publish)
        if (result == True):
            display_result(postid)


def store_post(title, slug, body):
    content = {}
    content['title'] = title
    content['description'] = body

    if (post_type == 'page'):
        content['post_type'] = 'page'

    if (slug != None): 
        content['wp_slug'] = slug

    log_DEBUG('store post ' + title)

    postid = find_postid(title)

    if (postid == None):
        result = server.metaWeblog.newPost(0, user, pw, content, False)
        if (result != None):
            display_result(result)

    else:
        result = server.metaWeblog.editPost(postid, user, pw, content, False)
        if (result == True):
            display_result(postid)
   

def find_postid(title):
    result = server.metaWeblog.getRecentPosts(0, user, pw, 9999)

    for it in result:
        if (it['title'] == title):
            return it['postid']

    return None

def find_pageid(title):
    result = server.wp.getPageList(0, user, pw)

    for it in result:
        if (it['page_title'] == title):
            postinfo = page_info(it['page_id'])
            if (postinfo['page_status'] != 'trash'):
                return it['page_id']

    return None


def upload_file(fname):
    with open(fname, 'rb') as f:
        data = f.read()

    md5 = hashlib.md5(data).hexdigest()
    bfile = os.path.basename(fname)

    if (registry.get(bfile) == md5):
        log_DEBUG('skipping ' + bfile + ', uploaded already')
        return registry[bfile+'_url']

    bits = xmlrpclib.Binary(data)
    content = {}
    content['bits'] = bits
    content['type'] = mimetypes.guess_type(fname)[0]
    content['name'] = os.path.basename(fname)

    result = server.metaWeblog.newMediaObject(0, user, pw, content)

    registry[bfile+'_url'] = result['url']
    registry[bfile] = md5

    print ("uploaded new file as " + result['url'])

    return unicode(result['url'])


### start

print ("posting to " + url)
print ("posted images registry: " + REGISTRY_FILE)
print ("---")

if (os.path.isfile(REGISTRY_FILE)):
    with codecs.open(REGISTRY_FILE, encoding='utf-8') as f:
        registry = json.load(f)
else:
    registry = {}

with codecs.open(sys.argv[5], encoding='utf-8') as f:
    lines = f.readlines()

body = []
images = {}
for it in lines:
    m = re.match(r'^%\s?file:\s*(.*)\n$', it)
    if (m):
        f = m.group(1)
        a = upload_file(f)

        images[os.path.basename(f)] = a
        continue

    m = re.match(r'^%\s?title:\s*(.*)\n$', it)
    if (m):
        title = m.group(1)
        continue

    m = re.match(r'^%\s?slug:\s*(.*)\n$', it)
    if (m):
        slug = m.group(1)
        continue


    for key in images.keys():
        img = images[key]

        it = it.replace('<img src="'+key+'"', '<img src="'+img+'"')

    body.append(it)
        

if (post_type == 'page'):
    store_page(title, slug, ''.join(body))
else:
    store_post(title, slug, ''.join(body))

#### save registry
with open(REGISTRY_FILE, 'w') as f:
    json.dump(registry, f)
