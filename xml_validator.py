#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# See http://lxml.de/validation.html

"""
Usage: xml_validator.py [-h] [-s SCHEMA] XML...

Arguments:
    XML         XML files to validate using the schema
Options:
    -h, --help              Print this help and exit
    -s, --schema SCHEMA     XML schema file
                            If missing, the DTD type is assumed using DOCTYPE

"""

from lxml import etree
from docopt import docopt


def main():
    args    = docopt(__doc__)
    schema  = args["--schema"]
    files   = args["XML"]

    if schema:
        schema_root = etree.XML(open(schema, 'rb').read())
        parser = etree.XMLParser(schema=etree.XMLSchema(schema_root))

    else:
        parser = etree.XMLParser(dtd_validation=True)

    for f in files:
        try:
            root = etree.fromstring(open(f, 'rb').read(), parser)

        except etree.XMLSyntaxError as e:
            print(f + ':', e)
            continue

if __name__ == "__main__":
    main()
