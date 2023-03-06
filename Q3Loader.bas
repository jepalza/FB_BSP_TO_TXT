
#include "Q3Loader.bi"
#include "crt.bi" ' funciones C de fichero FOPEN; FCLOSE; FREAD; FSEEK....


' Check if the header of the map is valid.
'
' @param pMap	The map to test.
' @return True if the map is valid, false otherwise.
Function isValid(pMap_ As TMapQ3  ) As byte 

	' magicnumber IBSP
	If ub2str(pMap_.mHeader.mMagicNumber()) <> cMagicNumber Then 
		return FALSE 
	End if

	' Check if the version number "2E" is equal to the Q3 map.
	' NOTA: algunos programas ponen la version como "2F", pero son identicos, 100% identicos.
	' asi que, mejoro el programa, indicando ambas versiones!!!
	if (pMap_.mHeader.mVersion <> cVersion) And (pMap_.mHeader.mVersion <> (cVersion+1)) Then 
		return FALSE 
   End If

	return TRUE 
End Function


' Read the header of the Q3 map.
'
' @param pFile	The stream on the Q3 file data.
' @param pMap	The map structure to fill.
Function readHeader(pFile as Integer, pMap_ As TMapQ3  ) As Byte 

	fread(@pMap_.mHeader, 1, sizeof(THeader), pFile) 

	return isValid(pMap_) 
End Function



' Read the entity lump of the Q3 map.
'
' @param pFile	The stream on the Q3 file data.
' @param pMap	The map structure to fill.
Sub readEntity(pFile as Integer, pMap_ As TMapQ3  )

	' Set the entity size.
	pMap_.mEntity.mSize = pMap_.mHeader.mLumpes(cEntityLump).mLength 

	' Allocate the entity buffer.
	pMap_.mEntity.mBuffer = Allocate(pMap_.mEntity.mSize) 

	' Go to the start of the chunk.
	fseek(pFile, pMap_.mHeader.mLumpes(cEntityLump).mOffset, SEEK_SET) 
	
	' Read the buffer.
	fread(pMap_.mEntity.mBuffer, pMap_.mEntity.mSize, sizeof(byte), pFile) 
End Sub 


' Read the texture lump of the Q3 map.
'
' @param pFile	The stream on the Q3 file data.
' @param pMap	The map structure to fill.
Sub readTexture(pFile as Integer, pMap_ As TMapQ3  )

	Dim As Integer	lNbTextures = pMap_.mHeader.mLumpes(cTextureLump).mLength / sizeof(TTexture) 

	' Go to the start of the chunk.
	fseek(pFile, pMap_.mHeader.mLumpes(cTextureLump).mOffset, SEEK_SET) 
	ReDim As TTexture pMap_.mTextures(lNbTextures-1) 
	Dim As TTexture lTexture 
	for lTextureCounter As Integer = 0 To lNbTextures-1       
		fread(@lTexture, 1, sizeof(TTexture), pFile) 
		pMap_.mTextures(lTextureCounter)=lTexture 
	Next
	
End Sub



' Read the plane lump of the Q3 map.
'
' @param pFile	The stream on the Q3 file data.
' @param pMap	The map structure to fill.
Sub readPlane(pFile as integer, pMap_ As TMapQ3  )

	Dim As Integer	lNbPlanes = pMap_.mHeader.mLumpes(cPlaneLump).mLength / sizeof(TPlane) 

	' Go to the start of the chunk.
	fseek(pFile, pMap_.mHeader.mLumpes(cPlaneLump).mOffset, SEEK_SET) 
	ReDim As TPlane pMap_.mPlanes(lNbPlanes-1)
	Dim As TPlane lPlane 
	for lPlaneCounter As Integer = 0 To lNbPlanes -1       
		fread(@lPlane, 1, sizeof(TPlane), pFile) 
		pMap_.mPlanes(lPlaneCounter)=(lPlane) 
	Next

End Sub


' Read the node lump of the Q3 map.
'
' @param pFile	The stream on the Q3 file data.
' @param pMap	The map structure to fill.
Sub readNode(pFile as Integer, pMap_ As TMapQ3  )

	Dim As Integer	lNbNodes = pMap_.mHeader.mLumpes(cNodeLump).mLength / sizeof(TNode) 

	' Go to the start of the chunk.
	fseek(pFile, pMap_.mHeader.mLumpes(cNodeLump).mOffset, SEEK_SET) 
	ReDim As TNode pMap_.mNodes(lNbNodes -1)
	Dim As TNode lNode 
	for lNodeCounter As Integer = 0 To lNbNodes -1       
		fread(@lNode, 1, sizeof(TNode), pFile) 
		pMap_.mNodes(lNodeCounter)=(lNode) 
	Next
	
End Sub


' Read the leaf lump of the Q3 map.
'
' @param pFile	The stream on the Q3 file data.
' @param pMap	The map structure to fill.
Sub readLeaf(pFile as Integer, pMap_ As TMapQ3  )

	Dim As Integer	lNbLeaves = pMap_.mHeader.mLumpes(cLeafLump).mLength / sizeof(TLeaf) 

	' Go to the start of the chunk.
	fseek(pFile, pMap_.mHeader.mLumpes(cLeafLump).mOffset, SEEK_SET) 
	ReDim As TLeaf pMap_.mLeaves(lNbLeaves -1)
	Dim As TLeaf lLeaf 
	for lLeafCounter As Integer = 0 To lNbLeaves -1       
		fread(@lLeaf, 1, sizeof(TLeaf), pFile) 
		pMap_.mLeaves(lLeafCounter)=(lLeaf) 
	Next
	
End Sub


' Read the leafface lump of the Q3 map.
'
' @param pFile	The stream on the Q3 file data.
' @param pMap	The map structure to fill.
Sub readLeafFace(pFile as Integer, pMap_ As TMapQ3  )

	Dim As Integer	lNbLeafFaces = pMap_.mHeader.mLumpes(cLeafFaceLump).mLength / sizeof(TLeafFace) 

	' Go to the start of the chunk.
	fseek(pFile, pMap_.mHeader.mLumpes(cLeafFaceLump).mOffset, SEEK_SET) 
	ReDim As TLeafFace pMap_.mLeafFaces(lNbLeafFaces -1)
	Dim As TLeafFace lLeafFace 
	for lLeafFaceCounter As Integer = 0 To lNbLeafFaces -1       
		fread(@lLeafFace, 1, sizeof(TLeafFace), pFile) 
		pMap_.mLeafFaces(lLeafFaceCounter)=(lLeafFace) 
	Next
			
End Sub


' Read the leafbrush lump of the Q3 map.
'
' @param pFile	The stream on the Q3 file data.
' @param pMap	The map structure to fill.
Sub readLeafBrush(pFile as Integer, pMap_ As TMapQ3  )

	Dim As Integer	lNbLeafBrushes = pMap_.mHeader.mLumpes(cLeafBrushLump).mLength / sizeof(TLeafBrush) 

	' Go to the start of the chunk.
	fseek(pFile, pMap_.mHeader.mLumpes(cLeafBrushLump).mOffset, SEEK_SET) 
	ReDim As TLeafBrush pMap_.mLeafBrushes(lNbLeafBrushes -1)
	Dim As TLeafBrush lLeafBrush 
	for lLeafBrusheCounter As Integer = 0 To lNbLeafBrushes -1       
		fread(@lLeafBrush, 1, sizeof(TLeafBrush), pFile) 
		pMap_.mLeafBrushes(lLeafBrusheCounter)=(lLeafBrush) 
	Next
	
End Sub


' Read the model lump of the Q3 map.
'
' @param pFile	The stream on the Q3 file data.
' @param pMap	The map structure to fill.
Sub readModel(pFile as Integer, pMap_ As TMapQ3  )

	Dim As Integer	lNbModels = pMap_.mHeader.mLumpes(cModelLump).mLength / sizeof(TModel) 

	' Go to the start of the chunk.
	fseek(pFile, pMap_.mHeader.mLumpes(cModelLump).mOffset, SEEK_SET) 
	ReDim As TModel pMap_.mModels(lNbModels -1)
	Dim As TModel lModel 
	for lModelCounter As Integer = 0 To lNbModels -1       
		fread(@lModel, 1, sizeof(TModel), pFile) 
		pMap_.mModels(lModelCounter)=(lModel) 
	Next

End Sub


' Read the brush lump of the Q3 map.
'
' @param pFile	The stream on the Q3 file data.
' @param pMap	The map structure to fill.
Sub readBrush(pFile as Integer, pMap_ As TMapQ3  )

	Dim As Integer	lNbBrushes = pMap_.mHeader.mLumpes(cBrushLump).mLength / sizeof(TBrush) 

	' Go to the start of the chunk.
	fseek(pFile, pMap_.mHeader.mLumpes(cBrushLump).mOffset, SEEK_SET) 
	ReDim As TBrush pMap_.mBrushes(lNbBrushes -1)
	Dim As TBrush lBrush 
	for lBrusheCounter As Integer = 0 To lNbBrushes -1       
		fread(@lBrush, 1, sizeof(TBrush), pFile) 
		pMap_.mBrushes(lBrusheCounter)=(lBrush) 
	Next

End Sub


' Read the brush side lump of the Q3 map.
'
' @param pFile	The stream on the Q3 file data.
' @param pMap	The map structure to fill.
Sub readBrushSide(pFile as Integer, pMap_ As TMapQ3  )

	Dim As Integer	lNbBrushSides = pMap_.mHeader.mLumpes(cBrushSideLump).mLength / sizeof(TBrushSide) 

	' Go to the start of the chunk.
	fseek(pFile, pMap_.mHeader.mLumpes(cBrushSideLump).mOffset, SEEK_SET) 
	ReDim As TBrushSide pMap_.mBrushSides(lNbBrushSides -1)
	Dim As TBrushSide lBrushSide 
	for lBrushSideCounter As Integer = 0 To lNbBrushSides -1       
		fread(@lBrushSide, 1, sizeof(TBrushSide), pFile) 
		pMap_.mBrushSides(lBrushSideCounter)=(lBrushSide) 
	Next

End Sub


' Read the vertex lump of the Q3 map.
'
' @param pFile	The stream on the Q3 file data.
' @param pMap	The map structure to fill.
Sub readVertex(pFile as Integer, pMap_ As TMapQ3  )

	Dim As Integer	lNbVertices = pMap_.mHeader.mLumpes(cVertexLump).mLength / sizeof(TVertex) 

	' Go to the start of the chunk.
	fseek(pFile, pMap_.mHeader.mLumpes(cVertexLump).mOffset, SEEK_SET) 
	ReDim As TVertex pMap_.mVertices(lNbVertices -1)
	Dim As TVertex lVertex 
	for lVerticeCounter As Integer = 0 To lNbVertices -1      
		fread(@lVertex, 1, sizeof(TVertex), pFile) 
		pMap_.mVertices(lVerticeCounter)=(lVertex) 
	Next

End Sub


' Read the meshvert lump of the Q3 map.
'
' @param pFile	The stream on the Q3 file data.
' @param pMap	The map structure to fill.
Sub readMeshVert(pFile as Integer, pMap_ As TMapQ3  )

	Dim As Integer	lNbMeshVertices = pMap_.mHeader.mLumpes(cMeshVertLump).mLength / sizeof(TMeshVert) 

	' Go to the start of the chunk.
	fseek(pFile, pMap_.mHeader.mLumpes(cMeshVertLump).mOffset, SEEK_SET) 
	ReDim As TMeshVert pMap_.mMeshVertices(lNbMeshVertices -1)
	Dim As TMeshVert lMeshVertex 
	for lVerticeCounter As Integer = 0 To lNbMeshVertices -1     
		fread(@lMeshVertex, 1, sizeof(TMeshVert), pFile)
		pMap_.mMeshVertices(lVerticeCounter)=(lMeshVertex) 
	Next

End Sub


' Read the effect lump of the Q3 map.
'
' @param pFile	The stream on the Q3 file data.
' @param pMap	The map structure to fill.
Sub readEffect(pFile as Integer, pMap_ As TMapQ3  )

	Dim As Integer	lNbEffects = pMap_.mHeader.mLumpes(cEffectLump).mLength / sizeof(TEffect) 

	' Go to the start of the chunk.
	fseek(pFile, pMap_.mHeader.mLumpes(cEffectLump).mOffset, SEEK_SET) 
	ReDim As TEffect pMap_.mEffects(lNbEffects -1)
	Dim As TEffect lEffect 
	for lEffectCounter As Integer = 0 To lNbEffects -1    
		fread(@lEffect, 1, sizeof(TEffect), pFile) 
		pMap_.mEffects(lEffectCounter)=(lEffect) 
	Next
	
End Sub


' Read the face lump of the Q3 map.
'
' @param pFile	The stream on the Q3 file data.
' @param pMap	The map structure to fill.
Sub readFace(pFile as Integer, pMap_ As TMapQ3  )

	Dim As Integer	lNbFaces = pMap_.mHeader.mLumpes(cFaceLump).mLength / sizeof(TFace) 

	' Go to the start of the chunk.
	fseek(pFile, pMap_.mHeader.mLumpes(cFaceLump).mOffset, SEEK_SET) 
	ReDim As TFace pMap_.mFaces(lNbFaces -1)
	Dim As TFace lFace 
	for lFaceCounter As Integer = 0 To lNbFaces -1     
		fread(@lFace, 1, sizeof(TFace), pFile) 
		pMap_.mFaces(lFaceCounter)=(lFace) 
	Next

End Sub


' Read the effect lump of the Q3 map.
'
' @param pFile	The stream on the Q3 file data.
' @param pMap	The map structure to fill.
Sub readLightMap(pFile as Integer, pMap_ As TMapQ3  )

	Dim As Integer	lNbLightMaps = pMap_.mHeader.mLumpes(cLightMapLump).mLength / sizeof(TLightMap) 

	' Go to the start of the chunk.
	fseek(pFile, pMap_.mHeader.mLumpes(cLightMapLump).mOffset, SEEK_SET) 
	ReDim As TLightMap pMap_.mLightMaps(lNbLightMaps -1)
	Dim As TLightMap lLightMap 
	for lLightMapCounter As Integer = 0 To lNbLightMaps -1      
		fread(@lLightMap, 1, sizeof(TLightMap), pFile) 
		pMap_.mLightMaps(lLightMapCounter)=(lLightMap) 
	Next

End Sub


' Read the effect lump of the Q3 map.
'
' @param pFile	The stream on the Q3 file data.
' @param pMap	The map structure to fill.
Sub readLightVol(pFile as Integer, pMap_ As TMapQ3  )

	Dim As Integer	lNbLightVols = pMap_.mHeader.mLumpes(cLightVolLump).mLength / sizeof(TLightVol) 

	' Go to the start of the chunk.
	fseek(pFile, pMap_.mHeader.mLumpes(cLightVolLump).mOffset, SEEK_SET) 
	ReDim As TLightVol pMap_.mLightVols(lNbLightVols -1)
	Dim As TLightVol lLightVol 
	for lLightVolCounter As Integer = 0 To lNbLightVols-1       
		fread(@lLightVol, 1, sizeof(TLightVol), pFile) 
		pMap_.mLightVols(lLightVolCounter)=(lLightVol) 
	Next

End Sub


' Read the effect lump of the Q3 map.
'
' @param pFile	The stream on the Q3 file data.
' @param pMap	The map structure to fill.
Sub readVisData(pFile as Integer, pMap_ As TMapQ3  )

	' Go to the start of the chunk.
	fseek(pFile, pMap_.mHeader.mLumpes(cVisDataLump).mOffset, SEEK_SET) 

	fread(@pMap_.mVisData.mNbClusters     , 1, sizeof(integer), pFile) 
	fread(@pMap_.mVisData.mBytesPerCluster, 1, sizeof(Integer), pFile) 

	' Allocate the buffer.
	Dim As Integer lBufferSize = pMap_.mVisData.mNbClusters * pMap_.mVisData.mBytesPerCluster 
	pMap_.mVisData.mBuffer = allocate(lBufferSize) 

	fread(pMap_.mVisData.mBuffer, lBufferSize, sizeof(ubyte)  , pFile) 
End Sub



' Dump all the Q3 map in a text file.
' Must be used only for debug purpose.
'
' @param pFile	The file to dump the informations.
' @param pMap	The Q3 map to dump in string.
Sub debugInformations(pMap_ As TMapQ3  , pFile As integer )

	' Check if the given stream is valid.
	If pFile=0 Then 
		Print "debugInformations :: Invalid stream handle." 
		Exit Sub  
   End If
 

	' Check if the map is valid.
	if isValid(pMap_)=0 Then 
		Print "debugInformations :: Invalid Q3 map header." 
		Exit Sub 
	End If
 

	fprintf(pFile, !"********* Header *********\n") 
	fprintf(pFile, !"Magic Number : %s\n", ub2str( pMap_.mHeader.mMagicNumber() ) ) 
	fprintf(pFile, !"Version      : %d\n", pMap_.mHeader.mVersion) 
	for lLumpCounter As Integer = 0 To 16      
		fprintf(pFile, !"Lump %d %s\n", lLumpCounter,lumps(lLumpCounter)) 
		fprintf(pFile, !"\tOffset : %d\n", pMap_.mHeader.mLumpes(lLumpCounter).mOffset) 
		fprintf(pFile, !"\tLength : %d\n", pMap_.mHeader.mLumpes(lLumpCounter).mLength) 
	Next

	fprintf(pFile, !"\n") 
	
	fprintf(pFile, !"********* 0: Entity Lump *********\n") 
	fprintf(pFile, !"Size : %d\n", pMap_.mEntity.mSize) 
	if (pMap_.mEntity.mSize <> 0) Then 
		fprintf(pFile, !"Buffer : %s\n", pMap_.mEntity.mBuffer) 
	End If
 
	fprintf(pFile, !"\n") 

	fprintf(pFile, !"********* 1: Texture Lump *********\n") 
	for lTextureCounter As Integer = 0 To ubound( pMap_.mTextures )       
		fprintf(pFile, !"Texture %d\n", lTextureCounter) 
		fprintf(pFile, !"\tName    : %s\n"  , ub2str( pMap_.mTextures(lTextureCounter).mName() ) ) 
		fprintf(pFile, !"\tFlags   : %08X\n", pMap_.mTextures(lTextureCounter).mFlags) 
		fprintf(pFile, !"\tContents: %08X\n", pMap_.mTextures(lTextureCounter).mContents) 
	Next

	fprintf(pFile, !"\n") 

	fprintf(pFile, !"********* 2: Plane Lump *********\n") 
	for lPlaneCounter As Integer = 0 To UBound( pMap_.mPlanes )       
		fprintf(pFile, !"Plane %d\n", lPlaneCounter) 
		fprintf(pFile, !"\tNormal   : %f %f %f\n", pMap_.mPlanes(lPlaneCounter).mNormal(0), pMap_.mPlanes(lPlaneCounter).mNormal(1), pMap_.mPlanes(lPlaneCounter).mNormal(2)) 
		fprintf(pFile, !"\tDistance : %f\n", pMap_.mPlanes(lPlaneCounter).mDistance) 
	Next

	fprintf(pFile, !"\n") 

	fprintf(pFile, !"********* 3: Node Lump *********\n") 
	for lNodeCounter As Integer = 0 To UBound( pMap_.mNodes )       
		fprintf(pFile, !"Node %d\n", lNodeCounter) 
		fprintf(pFile, !"\tPlane index   : %d\n"      , pMap_.mNodes(lNodeCounter).mPlane) 
		fprintf(pFile, !"\tChildren index: %d %d\n"   , pMap_.mNodes(lNodeCounter).mChildren(0), pMap_.mNodes(lNodeCounter).mChildren(1)) 
		fprintf(pFile, !"\tMin Bound Box : %d %d %d\n", pMap_.mNodes(lNodeCounter).mMins(0), pMap_.mNodes(lNodeCounter).mMins(1), pMap_.mNodes(lNodeCounter).mMins(2)) 
		fprintf(pFile, !"\tMax Bound Box : %d %d %d\n", pMap_.mNodes(lNodeCounter).mMaxs(0), pMap_.mNodes(lNodeCounter).mMaxs(1), pMap_.mNodes(lNodeCounter).mMaxs(2)) 
	Next

	fprintf(pFile, !"\n") 

	fprintf(pFile, !"********* 4: Leaf Lump *********\n") 
	For lLeafCounter As Integer = 0 To UBound( pMap_.mLeaves )     
		fprintf(pFile, !"Leaf %d\n", lLeafCounter) 
		fprintf(pFile, !"\tCluster %d\n", pMap_.mLeaves(lLeafCounter).mCluster) 
		fprintf(pFile, !"\tMin Bound Box : %d %d %d\n", pMap_.mLeaves(lLeafCounter).mMins(0), pMap_.mLeaves(lLeafCounter).mMins(1), pMap_.mLeaves(lLeafCounter).mMins(2)) 
		fprintf(pFile, !"\tMax Bound Box : %d %d %d\n", pMap_.mLeaves(lLeafCounter).mMaxs(0), pMap_.mLeaves(lLeafCounter).mMaxs(1), pMap_.mLeaves(lLeafCounter).mMaxs(2)) 
		fprintf(pFile, !"\tLeafFace      : %d\n", pMap_.mLeaves(lLeafCounter).mLeafFace) 
		fprintf(pFile, !"\tNb LeafFace   : %d\n", pMap_.mLeaves(lLeafCounter).mNbLeafFaces) 
		fprintf(pFile, !"\tLeafBrush     : %d\n", pMap_.mLeaves(lLeafCounter).mLeafBrush) 
		fprintf(pFile, !"\tNb LeafBrushes: %d\n", pMap_.mLeaves(lLeafCounter).mNbLeafBrushes) 
	Next

	fprintf(pFile, !"\n") 

	fprintf(pFile, !"********* 5: LeafFace Lump *********\n") 
	for lLeafFaceCounter As Integer = 0 To UBound( pMap_.mLeafFaces )       
		fprintf(pFile, !"LeafFace %d\n", lLeafFaceCounter) 
		fprintf(pFile, !"\tFaceIndex : %d\n", pMap_.mLeafFaces(lLeafFaceCounter).mFaceIndex) 
	Next

	fprintf(pFile, !"\n") 

	fprintf(pFile, !"********* 6: LeafBrush Lump *********\n") 
	for lLeafBrushCounter As Integer = 0 To UBound( pMap_.mLeafBrushes )        
		fprintf(pFile, !"LeafBrush %d\n", lLeafBrushCounter) 
		fprintf(pFile, !"\tBrushIndex : %d\n", pMap_.mLeafBrushes(lLeafBrushCounter).mBrushIndex) 
	Next

	fprintf(pFile, !"\n") 

	fprintf(pFile, !"********* 7: Model Lump *********\n") 
	for lModelCounter As Integer = 0 To UBound( pMap_.mModels )        
		fprintf(pFile, !"Model %d\n", lModelCounter) 
		fprintf(pFile, !"\tMin Bound Box : %d %d %d\n", pMap_.mModels(lModelCounter).mMins(0), pMap_.mModels(lModelCounter).mMins(1), pMap_.mModels(lModelCounter).mMins(2)) 
		fprintf(pFile, !"\tMax Bound Box : %d %d %d\n", pMap_.mModels(lModelCounter).mMaxs(0), pMap_.mModels(lModelCounter).mMaxs(1), pMap_.mModels(lModelCounter).mMaxs(2)) 
		fprintf(pFile, !"\tFace          : %d\n", pMap_.mModels(lModelCounter).mFace) 
		fprintf(pFile, !"\tNbFaces       : %d\n", pMap_.mModels(lModelCounter).mNbFaces) 
		fprintf(pFile, !"\tBrush         : %d\n", pMap_.mModels(lModelCounter).mBrush) 
		fprintf(pFile, !"\tNbBrushes     : %d\n", pMap_.mModels(lModelCounter).mNBrushes) 
	Next

	fprintf(pFile, !"\n") 

	fprintf(pFile, !"********* 8: Brush Lump *********\n") 
	for lBrushCounter As Integer = 0 To UBound( pMap_.mBrushes )        
		fprintf(pFile, !"Brush %d\n", lBrushCounter) 
		fprintf(pFile, !"\tBrushSide    : %d\n", pMap_.mBrushes(lBrushCounter).mBrushSide) 
		fprintf(pFile, !"\tNbBrushSides : %d\n", pMap_.mBrushes(lBrushCounter).mNbBrushSides) 
		fprintf(pFile, !"\tTextureIndex : %d\n", pMap_.mBrushes(lBrushCounter).mTextureIndex) 
	Next

	fprintf(pFile, !"\n") 

	fprintf(pFile, !"********* 9: BrushSide Lump *********\n") 
	for lBrushSideCounter As Integer = 0 To UBound( pMap_.mBrushSides )        
		fprintf(pFile, !"BrushSide %d\n", lBrushSideCounter) 
		fprintf(pFile, !"\tPlaneIndex   : %d\n", pMap_.mBrushSides(lBrushSideCounter).mPlaneIndex) 
		fprintf(pFile, !"\tTextureIndex : %d\n", pMap_.mBrushSides(lBrushSideCounter).mTextureIndex) 
	Next

	fprintf(pFile, !"\n") 

	fprintf(pFile, !"********* 10: Vertex Lump *********\n") 
	for lVertexCounter As Integer = 0 To UBound( pMap_.mVertices )        
		fprintf(pFile, !"Vertex %d\n", lVertexCounter) 
		fprintf(pFile, !"\tPosition  : %f %f %f\n"   , pMap_.mVertices(lVertexCounter).mPosition(0), pMap_.mVertices(lVertexCounter).mPosition(1), pMap_.mVertices(lVertexCounter).mPosition(2)) 
		fprintf(pFile, !"\tTex-Surf 0: %f %f\n"      , pMap_.mVertices(lVertexCounter).mTexCoord(0, 0), pMap_.mVertices(lVertexCounter).mTexCoord(0, 1)) 
		fprintf(pFile, !"\tTex-Ligh 1: %f %f\n"      , pMap_.mVertices(lVertexCounter).mTexCoord(1, 0), pMap_.mVertices(lVertexCounter).mTexCoord(1, 1)) 
		fprintf(pFile, !"\tNormal    : %f %f %f\n"   , pMap_.mVertices(lVertexCounter).mNormal(0), pMap_.mVertices(lVertexCounter).mNormal(1), pMap_.mVertices(lVertexCounter).mNormal(2)) 
		fprintf(pFile, !"\tColor     : %d %d %d %d\n", pMap_.mVertices(lVertexCounter).mColor(0), pMap_.mVertices(lVertexCounter).mColor(1), pMap_.mVertices(lVertexCounter).mColor(2), pMap_.mVertices(lVertexCounter).mColor(3)) 
	Next

	fprintf(pFile, !"\n") 

	fprintf(pFile, !"********* 11: MeshVert Lump *********\n") 
	for lMeshVertCounter As Integer = 0 To UBound( pMap_.mMeshVertices )        
		fprintf(pFile, !"MeshVert %d\n", lMeshVertCounter) 
		fprintf(pFile, !"\tVertex Index : %d\n", pMap_.mMeshVertices(lMeshVertCounter).mMeshVert) 
	Next

	fprintf(pFile, !"\n") 

	fprintf(pFile, !"********* 12: Effect Lump *********\n") 
	for lEffectCounter As Integer = 0 To UBound( pMap_.mEffects )        
		fprintf(pFile, !"Effect %d\n", lEffectCounter) 
		fprintf(pFile, !"\tName   : %s\n", ub2str( pMap_.mEffects(lEffectCounter).mName() ) ) 
		fprintf(pFile, !"\tBrush  : %d\n", pMap_.mEffects(lEffectCounter).mBrush) 
		fprintf(pFile, !"\tUnknown: %d\n", pMap_.mEffects(lEffectCounter).mUnknown) 
	Next

	fprintf(pFile, !"\n") 

	fprintf(pFile, !"********* 13: Face Lump *********\n") 
	for lFaceCounter As Integer = 0 To UBound( pMap_.mFaces )        
		fprintf(pFile, !"Face %d\n", lFaceCounter) 
		fprintf(pFile, !"\tTextureIndex   : %d\n", pMap_.mFaces(lFaceCounter).mTextureIndex) 
		fprintf(pFile, !"\tEffectIndex    : %d\n", pMap_.mFaces(lFaceCounter).mEffectIndex) 
		fprintf(pFile, !"\tType           : %d\n", pMap_.mFaces(lFaceCounter).mType) 
		fprintf(pFile, !"\tVertex         : %d\n", pMap_.mFaces(lFaceCounter).mVertex) 
		fprintf(pFile, !"\tNbVertices     : %d\n", pMap_.mFaces(lFaceCounter).mNbVertices) 
		fprintf(pFile, !"\tMeshVertex     : %d\n", pMap_.mFaces(lFaceCounter).mMeshVertex) 
		fprintf(pFile, !"\tNbMeshVertices : %d\n", pMap_.mFaces(lFaceCounter).mNbMeshVertices) 
		fprintf(pFile, !"\tLightMapIndex  : %d\n", pMap_.mFaces(lFaceCounter).mLightmapIndex) 
		fprintf(pFile, !"\tLightMapCorner : %d %d\n"   , pMap_.mFaces(lFaceCounter).mLightmapCorner(0), pMap_.mFaces(lFaceCounter).mLightmapCorner(1)) 
		fprintf(pFile, !"\tLightmapSize   : %d %d\n"   , pMap_.mFaces(lFaceCounter).mLightmapSize(0), pMap_.mFaces(lFaceCounter).mLightmapSize(1)) 
		fprintf(pFile, !"\tLightmapOrigin : %f %f %f\n", pMap_.mFaces(lFaceCounter).mLightmapOrigin(0), pMap_.mFaces(lFaceCounter).mLightmapOrigin(1), pMap_.mFaces(lFaceCounter).mLightmapOrigin(2)) 
		fprintf(pFile, !"\tLightmapVecs S : %f %f %f\n", pMap_.mFaces(lFaceCounter).mLightmapVecs(0, 0), pMap_.mFaces(lFaceCounter).mLightmapVecs(0, 1), pMap_.mFaces(lFaceCounter).mLightmapVecs(0, 2)) 
		fprintf(pFile, !"\tLightmapVecs T : %f %f %f\n", pMap_.mFaces(lFaceCounter).mLightmapVecs(1, 0), pMap_.mFaces(lFaceCounter).mLightmapVecs(1, 1), pMap_.mFaces(lFaceCounter).mLightmapVecs(1, 2)) 
		fprintf(pFile, !"\tNormal         : %f %f %f\n", pMap_.mFaces(lFaceCounter).mNormal(0), pMap_.mFaces(lFaceCounter).mNormal(1), pMap_.mFaces(lFaceCounter).mNormal(2)) 
		fprintf(pFile, !"\tPatchSize      : %d %d\n"   , pMap_.mFaces(lFaceCounter).mPatchSize(0), pMap_.mFaces(lFaceCounter).mPatchSize(1)) 
	Next

	fprintf(pFile, !"\n") 

	fprintf(pFile, !"********* 14: LightMap Lump *********\n") 
	fprintf(pFile, !"NbLightMaps %d\n", UBound( pMap_.mLightMaps ) ) 
	fprintf(pFile, !"\n") 

	fprintf(pFile, !"********* 15: LightVol Lump *********\n") 
	for lLightVolCounter As Integer = 0 To UBound( pMap_.mLightVols )       
		fprintf(pFile, !"LightVol %d\n", lLightVolCounter) 
		fprintf(pFile, !"\tAmbient     : %d %d %d\n", pMap_.mLightVols(lLightVolCounter).mAmbient(0), pMap_.mLightVols(lLightVolCounter).mAmbient(1), pMap_.mLightVols(lLightVolCounter).mAmbient(2)) 
		fprintf(pFile, !"\tDirectional : %d %d %d\n", pMap_.mLightVols(lLightVolCounter).mDirectional(0), pMap_.mLightVols(lLightVolCounter).mDirectional(1), pMap_.mLightVols(lLightVolCounter).mDirectional(2)) 
		fprintf(pFile, !"\tDir         : %d %d\n"   , pMap_.mLightVols(lLightVolCounter).mDir(0), pMap_.mLightVols(lLightVolCounter).mDir(1)) 
	Next

	fprintf(pFile, !"\n") 

	fprintf(pFile, !"********* 16: VisData Lump *********\n") 
	fprintf(pFile, !"\tNbCluster     : %d\n", pMap_.mVisData.mNbClusters) 
	fprintf(pFile, !"\tBytePerCluster: %d\n", pMap_.mVisData.mBytesPerCluster) 
	fprintf(pFile, !"\n") 
	
End Sub


' Read the map.
'
' @param pFilename	The filename of the map to read.
' @return true if the loading successed, false otherwise.
Function readMap( pFilename As String , pMap_ As TMapQ3 ) As Byte 

	'Dim As Integer lFile=FreeFile
	Dim As integer lFile = fopen(pFilename, "r+b")

	If lfile=0 Then Return FALSE
	
	'Open pFilename For Binary Access Read As lFile
	
	' Read the header.
	If readHeader(lFile, pMap_) = FALSE  Then 
		Print "readMap :: Invalid Q3 map header."
		return FALSE 
	End If
	
	' Read the entity lump.
	readEntity(lFile, pMap_) 

	' Read the texture lump.
	readTexture(lFile, pMap_) 

	' Read the plane lump.
	readPlane(lFile, pMap_) 

	' Read the node lump.
	readNode(lFile, pMap_) 

	' Read the leaf lump.
	readLeaf(lFile, pMap_) 

	' Read the leaf face lump.
	readLeafFace(lFile, pMap_) 

	' Read the leaf brush lump.
	readLeafBrush(lFile, pMap_) 

	' Read the model lump.
	readModel(lFile, pMap_) 

	' Read the brush lump.
	readBrush(lFile, pMap_) 

	' Read the brushside lump.
	readBrushSide(lFile, pMap_) 

	' Read the vertex lump.
	readVertex(lFile, pMap_) 

	' Read the meshvert lump.
	readMeshVert(lFile, pMap_) 

	' Read the effect lump.
	readEffect(lFile, pMap_) 

	' Read the face lump.
	readFace(lFile, pMap_) 

	' Read the lightmap lump.
	readLightMap(lFile, pMap_) 

	' Read the lightvol lump.
	readLightVol(lFile, pMap_) 

	' read the visdata lump.
	readVisData(lFile, pMap_) 
	
	' Close the file.
	Close lFile

	return TRUE 
End Function 


' Free all the datas of the map.
' tLightmapVecs
' @param pMap	The Q3 map to free.
Sub freeMap( pMap_ As TMapQ3 )
	If (pMap_.mEntity.mBuffer) Then 
		DeAllocate( pMap_.mEntity.mBuffer )
	End If
   
	If (pMap_.mVisData.mBuffer) Then 
		DeAllocate( pMap_.mVisData.mBuffer )
	End If
 
'	pMap_.mTextures.clear() 
'	pMap_.mPlanes.clear() 
'	pMap_.mNodes.clear() 			
'	pMap_.mLeaves.clear() 		
'	pMap_.mLeafFaces.clear() 		
'	pMap_.mLeafBrushes.clear() 	
'	pMap_.mModels.clear() 	
'	pMap_.mBrushes.clear() 	
'	pMap_.mBrushSides.clear() 
'	pMap_.mVertices.clear() 	
'	pMap_.mMeshVertices.clear() 
'	pMap_.mEffects.clear() 
'	pMap_.mFaces.clear() 	
'	pMap_.mLightMaps.clear() 
'	pMap_.mLightVols.clear() 
End Sub

