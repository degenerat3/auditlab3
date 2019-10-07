import argparse
import ipaddress
import urllib.request
import re
import gc
import concurrent.futures


def format_url(child, parent):
    c = urllib.parse.urlsplit(child)
    if not c.scheme or not c.netloc:
        # If partial path, or local path
        p = urllib.parse.urlsplit(parent)
        c = c._replace(scheme=p.scheme)
        c = c._replace(netloc=p.netloc)
        c = c._replace(path=urllib.parse.urljoin(p.path, c.path))
        if not c.query and p.query:
            c = c._replace(query=p.query)
    return urllib.parse.urlunsplit(c)


def extract(body):
    """
    Extract text
    """
    e = re.compile(b'[a-zA-Z0-9.\-_]+' + b'@' + b'[a-zA-Z0-9.-]+\.[a-zA-Z]{2,24}')
    emails = set(re.findall(e, body))
    u = re.compile(b'<a\s+(?:[^>]*?\s+)?href="([^"]*)"')
    # u = re.compile(b'<a\s+(?:[^>]*?\s+)?href=(["\'])(.*?)\1')
    # u = re.compile(b'[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)')
    links = set(re.findall(u, body))
    return emails, links


def get_page(url):
    """
    Scrape a webpage for emails
    """
    with urllib.request.urlopen(url) as conn:
        return conn.read()


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('url', help='url to begin crawl')
    parser.add_argument('-d', '--depth', help='depth to crawl (take care)')
    parser.add_argument('-s', '--scope', help='limit scope to certain domain')
    args = parser.parse_args()

    if not args.depth: depth = 2
    else: depth = args.depth

    visit = set({args.url})
    visited = set()
    for i in range(depth + 1):
        emails = set()

        content = dict()
        with concurrent.futures.ThreadPoolExecutor(max_workers=20) as executor:
            future_thread = {executor.submit(get_page, v):v for v in visit}
            for future in concurrent.futures.as_completed(future_thread):
                url = future_thread[future]
                try:
                    content[url] = future.result()
                except: pass # Let's be quiet..st.

        visited.update(visit)
        visit = set()

        with concurrent.futures.ThreadPoolExecutor(max_workers=20) as executor:
            future_thread = {executor.submit(extract, c):url for c, url in zip(content.values(), content.keys())}
            for future in concurrent.futures.as_completed(future_thread):
                url = future_thread[future]
                try:
                    results = future.result()
                    emails.update(results[0])
                    res = {format_url(item, url) for item in results[1]}
                    for url in res:
                        if url:
                            if scope in url: visit.add({url})
                            elif url: visit.add({url})
                except: pass # Let's be quiet...

        # del(content)

        for e in emails: print(e.decode())
        del(emails)
        gc.collect()
