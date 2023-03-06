' NOTA: los indices de las matrices, son TODAS "-1" por que FB empieza en 0, por lo tanto, "mLumpes(16)" son 17 lumps
' los que implican "textos", tambien  son -1, pero estos son UBYTE y luego se leen con UB2STR

' Description of a lump.
Type TLump Field=1
   As Long    mOffset         	 ' Offset to start of lump, relative to beginning of file.
   As long    mLength         	 ' Length of lump. Always a multiple of 4.
End Type

' Header of the Q3 map.
Type THeader Field=1
   As UByte   mMagicNumber(3) 	 ' Magic number. Always "IBSP".
   As long    mVersion            ' Version number &h2e for the BSP files distributed with Quake 3.
   As TLump   mLumpes(16)     	 ' Lump directory, seventeen entries.
End Type

' Entity of the Q3 map, map name, weapons, health, armor, triggers, spawn points, lights, .md3 models to be placed
Type TEntity Field=1
   As Long    mSize               ' Size of the description.
   As zstring Ptr mBuffer         ' Entity descriptions, stored as a string.
End Type

' Texture of the Q3 map, surfaces and volumes, which are in turn associated with faces, brushes, and brushsides.
Type TTexture Field=1
   As UByte   mName(63)           ' Texture name.
   As Long    mFlags              ' Surface flags.
   As Long    mContents           ' Content flags.
End Type

' Plane of the Q3 map, a generic set of planes that are in turn referenced by nodes and brushsides.
Type TPlane Field=1
   As Single    mNormal(2)           ' Plane normal.
   As single    mDistance            ' Distance from origin to plane along normal.
End Type

' Node of the Q3 map, all of the nodes in the map's BSP tree.
Type TNode Field=1
   As Long    mPlane              ' Plane index.
   As Long    mChildren(1)        ' Children indices. Negative numbers are leaf indices: -(leaf+1).
   As long    mMins(2)            ' long bounding box min coord.
   As long    mMaxs(2)            ' long bounding box max coord.
End Type

' Leaf of the Q3 map, the leaves of the map's BSP tree.
Type TLeaf Field=1
   As Long    mCluster            ' Visdata cluster index.
   As Long    mArea               ' Areaportal area.
   As long    mMins(2)            ' long bounding box min coord.
   As long    mMaxs(2)            ' long bounding box max coord.
   As Long    mLeafFace           ' First leafface for leaf.
   As Long    mNbLeafFaces        ' Number of leaffaces for leaf.
   As Long    mLeafBrush          ' First leafbrush for leaf.
   As Long    mNbLeafBrushes      ' Number of leafbrushes for leaf.
End Type

' LeafFace of the Q3 map, lists of face indices, with one list per leaf.
Type TLeafFace Field=1
   As Long    mFaceIndex          ' Face index.
End Type

' Leaf Brush of the Q3 map, lists of brush indices, with one list per leaf.
Type TLeafBrush Field=1
   As Long    mBrushIndex     	 ' Brush index.
End Type

' Model of the Q3 map, describes rigid groups of world geometry.
Type TModel Field=1
   As single  mMins(2)            ' Bounding box min coord.
   As single  mMaxs(2)            ' Bounding box max coord.
   As Long    mFace               ' First face for model.
   As Long    mNbFaces            ' Number of faces for model.
   As Long    mBrush              ' First brush for model.
   As Long    mNBrushes           ' Number of brushes for model.
End Type

' Brush of the Q3 map, a set of brushes, which are in turn used for collision detection.
Type TBrush Field=1
   As Long    mBrushSide          ' First brushside for brush.
   As Long    mNbBrushSides       ' Number of brushsides for brush.
   As Long    mTextureIndex       ' Texture index.
End Type

' BrushSide of the Q3 map, descriptions of brush bounding surfaces.
Type TBrushSide Field=1
   As Long    mPlaneIndex     	 ' Plane index.
   As Long    mTextureIndex       ' Texture index.
End Type

' Vertex of the Q3 map, lists of vertices used to describe faces.
Type TVertex Field=1
   As single   mPosition(2)        ' Vertex position.
   As single   mTexCoord(1,1)  	  ' Vertex texture coordinates. 0 = Surface, 1 = Lightmap.
   As single   mNormal(2)          ' Vertex normal.
   As ubyte    mColor(3)           ' Vertex color (RGBA).
End Type

' MeshVert of the Q3 map, lists of vertex offsets, used to describe generalized triangle meshes.
Type TMeshVert Field=1
   As Long    mMeshVert           ' Vertex index offset, relative to first vertex of corresponding face.
End Type

' Effect of the Q3 map, references to volumetric shaders (typically fog) which affect the rendering of a particular group of faces.
Type TEffect Field=1
   As UByte   mName(63)           ' Effect shader.
   As Long    mBrush              ' Brush that generated this effect.
   As Long    mUnknown            ' Always 5, except in q3dm8, which has one effect with -1.
End Type

' Face of the Q3 map: stores information used to render the surfaces of the map.
Type TFace Field=1
   As Long    mTextureIndex       ' Texture index.
   As Long    mEffectIndex        ' Index into lump 12 (Effects), or -1.
   As Long    mType               ' Face type. 1 = Polygon, 2 = Patch, 3 = Mesh, 4 = Billboard.
   As Long    mVertex         	 ' Index of first vertex.
   As Long    mNbVertices     	 ' Number of vertices.
   As Long    mMeshVertex     	 ' Index of first meshvert.
   As Long    mNbMeshVertices 	 ' Number of meshverts.
   As Long    mLightmapIndex      ' Lightmap index.
   As Long    mLightmapCorner(1)  ' Corner of this face's lightmap image in lightmap.
   As Long    mLightmapSize(1)    ' Size of this face's lightmap image in lightmap.
   As single  mLightmapOrigin(2)  ' World space origin of lightmap.
   As single  mLightmapVecs(1,2)	 ' World space lightmap s and t unit vectors.
   As Single  mNormal(2)          ' Surface normal.
   As Long    mPatchSize(1)       ' Patch dimensions.
End Type

' Lightmap of the Q3 map: the light map textures used make surface lighting look more realistic.
Type TLightMap Field=1
   As ubyte   mMapData(127,127,2) ' Lightmap color data. RGB.
End Type

' Light volume of the Q3 map, a uniform grid of lighting information used to illuminate non-map objects.
Type TLightVol Field=1
   As ubyte   mAmbient(2)     	 ' Ambient color component. RGB.
   As ubyte   mDirectional(2) 	 ' Directional color component. RGB.
   As ubyte   mDir(1)         	 ' Direction to light. 0=phi, 1=theta.
End Type

' The Visibility data of the Q3 map, bit vectors that provide cluster-to-cluster visibility information.
Type TVisData Field=1
   As Long    mNbClusters     	 ' The number of clusters
   As Long    mBytesPerCluster    ' Bytes (8 bits) in the cluster's bitset
   As UByte ptr mBuffer           ' Array of bytes holding the cluster vis.
End Type




''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' The Q3 map definition.
' The Q3 map is defined by 17 lumps and a header section.
' se redimensionan al conocer su numero de elementos
Type TMapQ3
    As 		 THeader		 mHeader     		' Header of the file.
    As 		 TEntity		 mEntity     		' Array of the leaves.
    ReDim As TTexture 	 mTextures(1)     ' Array of the textures.
    ReDim As TPlane 		 mPlanes(1)     	' Array of the planes.
    ReDim As TNode 		 mNodes(1)        ' Array of the nodes.
    ReDim As TLeaf 		 mLeaves(1)     	' Array of the leaves.
    ReDim As TLeafFace 	 mLeafFaces(1)    ' Array of the leaf faces.
    ReDim As TLeafBrush  mLeafBrushes(1)  ' Array of the leaf brushes.
    ReDim As TModel 		 mModels(1)     	' Array of the models.
    ReDim As TBrush 		 mBrushes(1)      ' Array of the brushes.
    ReDim As TBrushSide  mBrushSides(1) 	' Array of the brush sides.
    ReDim As TVertex 	 mVertices(1)     ' Array of the vertices.
    ReDim As TMeshVert 	 mMeshVertices(1) ' Array of the mesh vertices.
    ReDim As TEffect 	 mEffects(1)      ' Array of the effects.
    ReDim As TFace 		 mFaces(1)        ' Array of the faces.
    ReDim As TLightMap 	 mLightMaps(1)    ' Array of the light maps.
    ReDim As TLightVol 	 mLightVols(1)    ' Array of the light volumes.
    As 		 TVisData	 mVisData  		   ' The visibility datas.
End type



' Constant for the ID Software Magic number.
const As string cMagicNumber = "IBSP"

' Constant for the Q3 Map version.
Const As Byte cVersion        = &h2E

' Constant identifier for all the lumps.
Const As Byte cEntityLump     = &h00 ' Entities : Game-related object descriptions.
Const As Byte cTextureLump    = &h01 ' Textures : Surface descriptions.
Const As Byte cPlaneLump      = &h02 ' Planes : Planes used by map geometry.
Const As Byte cNodeLump       = &h03 ' Nodes : BSP tree nodes.
Const As Byte cLeafLump       = &h04 ' Leafs : BSP tree leaves.
Const As Byte cLeafFaceLump   = &h05 ' LeafFaces : Lists of face indices, one list per leaf.
Const As Byte cLeafBrushLump  = &h06 ' LeafBrushes  Lists of brush indices, one list per leaf.
Const As Byte cModelLump      = &h07 ' Models  Descriptions of rigid world geometry in map.
Const As Byte cBrushLump      = &h08 ' Brushes  Convex polyhedra used to describe solid space.
Const As Byte cBrushSideLump  = &h09 ' Brushsides  Brush surfaces.
Const As Byte cVertexLump     = &h0A ' Vertexes  Vertices used to describe faces.
Const As Byte cMeshVertLump   = &h0B ' MeshVerts  Lists of offsets, one list per mesh.
Const As Byte cEffectLump     = &h0C ' Effects  List of special map effects.
Const As Byte cFaceLump       = &h0D ' Faces  Surface geometry.
Const As Byte cLightMapLump   = &h0E ' LightMaps  Packed lightmap data.
Const As Byte cLightVolLump   = &h0F ' LightVols  Local illumination data.
Const As Byte cVisDataLump    = &h10 ' Visdata  Cluster-cluster visibility data.

Dim Shared As String lumps(15)
Lumps (&h00) = "Entity"    
Lumps (&h01) = "Texture"   
Lumps (&h02) = "Plane"     
Lumps (&h03) = "Node"      
Lumps (&h04) = "Leaf"      
Lumps (&h05) = "LeafFace"  
Lumps (&h06) = "LeafBrush" 
Lumps (&h07) = "Model"     
Lumps (&h08) = "Brush"     
Lumps (&h09) = "BrushSide" 
Lumps (&h0A) = "Vertex"    
Lumps (&h0B) = "MeshVert"  
Lumps (&h0C) = "Effect"    
Lumps (&h0D) = "Face"      
Lumps (&h0E) = "LightMap"  
Lumps (&h0F) = "LightVol"  
Lumps (&h10) = "VisData" 


' Dump all the Q3 map in a text file.
' Must be used only for debug purpose.
'
' pFile  The file to dump the informations.
' pMap_  The Q3 map to dump in string.
Declare Sub debugInformations( pMap_ As TMapQ3 , pFile As integer )


' Read the map.
'
' pFilename The filename of the map to read.
' return TRUE if the loading successed, false otherwise.
Declare Function readMap( pFilename As string, pMap_ As TMapQ3  ) As Byte


' Free all the datas of the map.
'
' pMap_  The Q3 map to free.
Declare sub freeMap( pMap_ As TMapQ3  )


' Check if the header of the map is valid.
'
' pMap_  The map to test.
' return TRUE if the map is valid, false otherwise.
Declare function isValid( pMap_ As TMapQ3 ) As Byte


' lee los UBYTE de un array y lo devuelve como TEXTO
Function ub2str( ub() As UByte ) As String
    Dim As Long length = UBound(ub) + 1
    Dim As String res = Space(length)
    For i As long = 0 To length-1
        res[i] = ub(i)
    Next
    Function = res
End Function