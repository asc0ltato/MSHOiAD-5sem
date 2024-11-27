use Map;
create database Map;
SELECT SCHEMA_NAME
FROM INFORMATION_SCHEMA.SCHEMATA

-- 6.���������� ��� ���������������� ������ �� ���� ��������
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'

-- 7.���������� SRID - ������������� ������� ���������
SELECT SRID FROM dbo.spatial_ref_sys;
SELECT SRID FROM dbo.geometry_columns;

-- 8.���������� ������������ �������
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo' AND DATA_TYPE != 'geometry'

-- 9.������� �������� ���������������� �������� � ������� WKT
SELECT geom.STAsText() AS WKT FROM ne_110m_geography_regions_polys;

----
SELECT * FROM ne_110m_geography_regions_polys order by name_ru;
-- 10.1.���������� ����������� ���������������� ��������;
SELECT obj1.geom.STIntersection(obj2.geom) AS Intersection
FROM ne_110m_geography_regions_polys obj1, ne_110m_geography_regions_polys obj2
WHERE obj1.qgs_fid = 3 AND obj2.qgs_fid = 5;

SELECT name_ru FROM ne_110m_geography_regions_polys n WHERE n.qgs_fid = 3;
SELECT name_ru FROM ne_110m_geography_regions_polys n WHERE n.qgs_fid = 5;

-- 10.2.���������� ����������� ���������������� ��������;
SELECT obj1.geom.STUnion(obj2.geom) AS [Union]
FROM ne_110m_geography_regions_polys obj1, ne_110m_geography_regions_polys obj2
WHERE obj1.qgs_fid = 3 AND obj2.qgs_fid = 57;

SELECT name_ru FROM ne_110m_geography_regions_polys n WHERE n.qgs_fid = 3;
SELECT name_ru FROM ne_110m_geography_regions_polys n WHERE n.qgs_fid = 57;

-- 10.3.���������� ����������� ���������������� ��������;
SELECT obj1.geom.STWithin(obj2.geom) AS [Within]
FROM ne_110m_geography_regions_polys obj1, ne_110m_geography_regions_polys obj2
WHERE obj1.qgs_fid = 41 AND obj2.qgs_fid = 7;

SELECT name_ru FROM ne_110m_geography_regions_polys n WHERE n.qgs_fid = 41;
SELECT name_ru FROM ne_110m_geography_regions_polys n WHERE n.qgs_fid = 7;
-- 10.4.��������� ����������������� �������;
SELECT geom.Reduce(0.1) AS Reduce
FROM ne_110m_geography_regions_polys WHERE qgs_fid = 57;

SELECT name_ru FROM ne_110m_geography_regions_polys n WHERE n.qgs_fid = 57;

-- 10.5.���������� ��������� ������ ����������������� ��������
SELECT geom.STPointN(1).ToString() ASCoordinates
FROM ne_110m_geography_regions_polys WHERE qgs_fid = 57;

-- 10.6.���������� ����������� ���������������� ��������
SELECT geom.STDimension() AS Dimension
FROM ne_110m_geography_regions_polys WHERE qgs_fid = 57;

-- 10.7.���������� ����� � ������� ���������������� ��������;
SELECT geom.STLength() AS [Length], geom.STArea() AS Area
FROM ne_110m_geography_regions_polys WHERE qgs_fid = 57;

-- 10.8.���������� ���������� ����� ����������������� ���������;
SELECT obj1.geom.STDistance(obj2.geom) AS Distance
FROM ne_110m_geography_regions_polys obj1, ne_110m_geography_regions_polys obj2
WHERE obj1.qgs_fid = 57 AND obj2.qgs_fid = 3;

SELECT name_ru FROM ne_110m_geography_regions_polys n WHERE n.qgs_fid = 3;
SELECT name_ru FROM ne_110m_geography_regions_polys n WHERE n.qgs_fid = 57;

-- 11.	�������� ���������������� ������ � ���� ����� (1) /����� (2) /�������� (3).
DECLARE @pointGeometry GEOMETRY;
SET @pointGeometry = GEOMETRY::STGeomFromText('POINT(3 57)', 0);
SELECT @pointGeometry AS PointGeometry;

DECLARE @lineGeometry GEOMETRY;
SET @lineGeometry = GEOMETRY::STGeomFromText('LINESTRING(1 1, 2 2, 3 3)', 0);
SELECT @lineGeometry AS LineGeometry;

DECLARE @polygonGeometry GEOMETRY;
SET @polygonGeometry = GEOMETRY::STGeomFromText('POLYGON((1 1, 1 100, 100 100, 100 1, 1 1))', 0);
SELECT @polygonGeometry AS PolygonGeometry;

-- 12.	�������, � ����� ���������������� ������� �������� ��������� ���� �������
-- ����� � �������
GO
DECLARE @pointGeometry GEOMETRY;
SET @pointGeometry = GEOMETRY::STGeomFromText('POINT(3 57)', 0);
DECLARE @polygonGeometry GEOMETRY;
SET @polygonGeometry = GEOMETRY::STGeomFromText('POLYGON((1 1, 1 100, 100 100, 100 1, 1 1))', 0);
SELECT @pointGeometry.STWithin(@polygonGeometry) AS PointWithinPolygon;

GO
DECLARE @lineGeometry GEOMETRY;
SET @lineGeometry = GEOMETRY::STGeomFromText('LINESTRING(1 1, 2 2, 3 3)', 0);
DECLARE @polygonGeometry GEOMETRY;
SET @polygonGeometry = GEOMETRY::STGeomFromText('POLYGON((1 1, 1 100, 100 100, 100 1, 1 1))', 0);
SELECT @lineGeometry.STWithin(@polygonGeometry) AS LineWithinPolygon;