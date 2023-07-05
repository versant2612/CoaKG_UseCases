import pygeos as pg
from pygeos import Geometry

def geo_intersection(geo1, geo2):

  pol1 = pg.Geometry(geo1)
  pol2 = pg.Geometry(geo2)

  return str(pg.intersection(pol1, pol2))

def geo_intersects(geo1, geo2):

  pol1 = pg.Geometry(geo1)
  pol2 = pg.Geometry(geo2)

  return str(pg.intersects(pol1, pol2))

def geo_operation(geo1, geo2):

  pol1 = pg.Geometry(geo1)
  pol2 = pg.Geometry(geo2)

  if pg.intersects(pol1, pol2): return "ckgr5:intersects"