#!/usr/bin/ruby
# encoding: utf-8
#--
class LWComponentKeywords
	attr_accessor :conf
	def initialize()
		#--
	end
	def self.getNodeKeywords(node)
		node.getMetadataList().getMetadata().map{|m|
		   m.getValue()
		}
	end
	def self.selectNodesByKeyword(keyword, nodes)
		nodes.select{|n|
		   nodeKeywords = LWComponentKeywords.getNodeKeywords(n)
		   nodeKeywords.include?(keyword)
		}
	end
end
class Utils
	attr_accessor :conf
	def initialize()
		#--
	end
	def self.makeGroupOfNodes(list)
		s = LWSelection.new(list);
		group = LWGroup.create(s)
		VUE.getActiveViewer().getDropFocal().pasteChild(group)
		group
	end
	def self.getSelectedWithLabels()
		s = VUE.getSelection().iterator()
		nodes = s.select{ |n|
		!n.getLabel().nil? && n.getLabel() != "mLWC"
		}
		nodes
	end
	def self.getSourceBranches()
		sourceRoot = $mLWC.getOutgoingLinks().first().getTail()
		sourceBranches = sourceRoot.getOutgoingLinks().map{|l|
		l.getTail()
		}
		sourceBranches
	end
	def self.makeNode(nodeLabel, yShift)
		node =NodeModeTool.createNewNode(nodeLabel);
		rPosition =VUE.getActiveViewer().getLastMousePressMapPoint();
		x = rPosition.getX() + 700;
		y = rPosition.getY() + yShift;
		rP = Float.new(x, y);
		node.setLocation(rP);
		VUE.getActiveViewer().getDropFocal().pasteChild(node);
		node
	end
	def self.makeAndPlaceNode(nodeLabel, xShift, yShift)
		node =NodeModeTool.createNewNode(nodeLabel);
		rPosition =VUE.getActiveViewer().getLastMousePressMapPoint();
		x = rPosition.getX() + xShift;
		y = rPosition.getY() + yShift;
		rP = Float.new(x, y);
		node.setLocation(rP);
		VUE.getActiveViewer().getDropFocal().pasteChild(node);
		node
	end
	def self.makeAndPlaceNodeForXAndY(nodeLabel, x, y)
		node =NodeModeTool.createNewNode(nodeLabel);
		rP = Float.new(x, y);
		node.setLocation(rP);
		VUE.getActiveViewer().getDropFocal().pasteChild(node);
		node
	end
	def self.duplicateAndPlaceNode(node, xShift, yShift)
		newNode = node.duplicate();
		rPosition =VUE.getActiveViewer().getLastMousePressMapPoint();
		x = rPosition.getX() + xShift;
		y = rPosition.getY() + yShift;
		rP = Float.new(x, y);
		newNode.setLocation(rP);
		VUE.getActiveViewer().getDropFocal().pasteChild(newNode);
		newNode
	end
	def self.duplicateAndPlaceNodeForXAndY(node, x, y)
		newNode = node.duplicate();
		rP = Float.new(x, y);
		newNode.setLocation(rP);
		VUE.getActiveViewer().getDropFocal().pasteChild(newNode);
		newNode
	end
	def self.makeAndPlaceNodeWithImage(nodeLabel, imgPath, imgMaxDimension, x, y)
		node =NodeModeTool.createNewNode(nodeLabel);
		rP = Float.new(x, y);
		node.setLocation(rP);
		VUE.getActiveViewer().getDropFocal().pasteChild(node);
		image = LWImage.new()
		resource = node.getResourceFactory().get(imgPath);
		image.setAutoSized(true);
		image.setLabel(resource.getTitle());
		image.setResource(resource)
		image.setMaxDimension(imgMaxDimension);
		node.addChild(image)
		node
	end
	def self.replaceImageInNodeWithImage(node, newImgPath, newImgMaxDimension)
		node.getChildren().first().delete()
		resource = node.getResourceFactory().get(newImgPath);
		image = LWImage.new()
		image.setAutoSized(true);
		image.setLabel(resource.getTitle());
		image.setResource(resource)
		image.setMaxDimension(newImgMaxDimension);
		node.setResource(image.getResource())
		node
	end
	def self.getDesktopPositionForVUEPosition(mapX, mapY)
		v = VUE.getActiveViewer()
		mViewport = v.getParent()
		x = mViewport.getViewPosition().getX()
		y = mViewport.getViewPosition().getY()
		originX = v.getOriginX()
		originY = v.getOriginY()
		mZoomFactor = v.getZoomFactor()
		screenX = (0.5 + ((mapX*mZoomFactor) - originX)).to_i
		screenY = (0.5 + ((mapY*mZoomFactor) - originY)).to_i
		left = (screenX - x) + 5
		top = (screenY - y) + 132
		return left, top
	end
	def self.getDesktopPositionForVUEPositionInRightPane(mapX, mapY)
		v = VUE.getRightTabbedPane().getSelectedViewer()
		mViewport = v.getParent()
		x = mViewport.getViewPosition().getX()
		y = mViewport.getViewPosition().getY()
		originX = v.getOriginX()
		originY = v.getOriginY()
		mZoomFactor = v.getZoomFactor()
		screenX = (0.5 + ((mapX*mZoomFactor) - originX)).to_i
		screenY = (0.5 + ((mapY*mZoomFactor) - originY)).to_i
		left = (screenX - x) + 967
		top = (screenY - y) + 132
		return left, top
	end
	def self.getNodeOutgoingBranchesNodes(node)
		if !node.getOutgoingLinks().nil?
		   node.getOutgoingLinks().map{|l| l.getTail() }
		else
		   []
		end
	end
	def self.getTextNodeLabel(textNode)
		children = textNode.getChildren()
		
		children.select{|c|
		   c.is_a?(LWText)
		}.first.getDisplayLabel()
	end
	def self.setTextNodeLabel(textNode, newLabel)
		children = textNode.getChildren()
		textNodeWidth = 150
		textNodeHeight = 150
		textNodeLabel = ""
		while children.size > 0 do
		   c = children.first
		   if c.is_a?(LWText) && !c.getDisplayLabel().nil?
		      textNodeWidth = c.getWidth()
		      textNodeHeight = c.getHeight()
		      textNodeLabel = c.getDisplayLabel()
		   end
		   c.java_send(:delete)
		end
		
		t = NodeModeTool.createRichTextNode(newLabel)
		t.setSize(textNodeWidth, textNodeHeight)
		textNode.addChild(t)
		textNode
	end
end
class VueNodesTable
	attr_accessor :conf,
	:allNodes,
	:tableNodes
	def initialize()
		@tableNodes = nil
		@allNodes = VUE.getActiveMap().getAllNodesIterator().map{|n| n}
	end
	def getNodeTableName(node)
		tableName = nil
		keywords = node.getMetadataList().getMetadata().map{|m|
		   m.getValue()
		}
		tableName = keywords.select {|k|
		   k.start_with?("tableName: ")
		}.first.split(": ").last
		tableName
	end
	def getNodesOfTableByTableName(nodesList, tableName)
		if @tableNodes.nil? || @tableNodes.size == 0
		   nodesByKeyword = LWComponentKeywords.selectNodesByKeyword("tableName: " + tableName, nodesList)
		   learnObjectNodes = LWComponentKeywords.selectNodesByKeyword("learnObject", nodesByKeyword)
		   @tableNodes = (nodesByKeyword - learnObjectNodes)
		end
		@tableNodes
	end
	def getNodesTableRowForNode(node)
		tableName = getNodeTableName(node)
		tableAllNodes = getNodesOfTableByTableName(@allNodes, tableName)
		rootY1 = node.y
		rootY2 = node.y + node.getHeight
		rowNodes = tableAllNodes.select{|n|
		   nY1 = n.y
		   nY2 = n.y + n.getHeight
		   (nY1 <= rootY2) && (nY2 >= rootY1)
		}
		rowNodes = rowNodes.sort_by {|item| item.x}
		rowNodes
	end
	def getNodesTableColumnForNode(node)
		tableName = getNodeTableName(node)
		tableAllNodes = getNodesOfTableByTableName(@allNodes, tableName)
		rootX1 = node.x
		rootX2 = node.x + node.getWidth
		columnNodes = tableAllNodes.select{|n|
		   nX1 = n.x
		   nX2 = n.x + n.getWidth
		   (nX1 <= rootX2) && (nX2 >= rootX1)
		}
		columnNodes = columnNodes.sort_by {|item| item.y}
		columnNodes
	end
	def getTableUpperLeftNode(tableName)
		tableAllNodes = getNodesOfTableByTableName(@allNodes, tableName)
		leftestNode = tableAllNodes.sort_by{|n| n.x }.first
		upperestNode = tableAllNodes.sort_by{|n| n.y }.first
		firstNodeInFirstRow = getNodesTableRowForNode(upperestNode).first
		firstNodeInFirstColumn = getNodesTableColumnForNode(leftestNode).first
		if firstNodeInFirstRow == firstNodeInFirstColumn
		   return firstNodeInFirstRow
		else
		   return nil
		end
	end
	def getColumnNodesByColumnNumber(columnNumber, tableName)
		upperLeftNode = getTableUpperLeftNode(tableName)
		firstRowNodes = getNodesTableRowForNode(upperLeftNode)
		columnStartNode = firstRowNodes[columnNumber]
		getNodesTableColumnForNode(columnStartNode)
	end
	def getRowNodesByRowNumber(rowNumber, tableName)
		upperLeftNode = getTableUpperLeftNode(tableName)
		firstColumnNodes = getNodesTableColumnForNode(upperLeftNode)
		rowStartNode = firstColumnNodes[rowNumber]
		getNodesTableRowForNode(rowStartNode)
	end
end
class TableStudy
	attr_accessor :conf,
	:tableName,
	:vND,
	:setupNodesKeywordName,
	:shuffleOrder,
	:testTableSize,
	:gradeNodeKeyword,
	:learnColumnNumber,
	:testColumnNumber,
	:testTableStepX,
	:testTableStepY,
	:additionalLearnColumns,
	:additionalTestColumns,
	:additionalLearnColumnsStepX,
	:additionalLearnColumnsStepY,
	:additionalTestColumnsStepX,
	:additionalTestColumnsStepY,
	:testTableX,
	:testTableY,
	:learnAdditionalColumnsSide,
	:testAdditionalColumnsSide,
	:setupY,
	:learnItemX,
	:learnItemY,
	:gradeX,
	:gradeY,
	:testShowLogNodeLabel,
	:testCheckLogNodeLabel
	def initialize(tableName)
		@tableName = tableName
		@vND = VueNodesTable.new()
		@gradeNodeKeyword = "gradeNode"
		@testShowLogNodeLabel = "testShowLog"
		@testCheckLogNodeLabel = "testCheckLog"
	end
	def studyTable()
		buildSetupNodes()
		
		learnColumnNodes = @vND.getColumnNodesByColumnNumber(@learnColumnNumber, @tableName)
		testColumnNodes = @vND.getColumnNodesByColumnNumber(@testColumnNumber, @tableName) if !@testColumnNumber.nil?
		
		additionalTestColumnsNodes = @additionalTestColumns.map{|columnNumber|
		   @vND.getColumnNodesByColumnNumber(columnNumber, @tableName)
		}
		
		learnColumnSelectedNodes = learnColumnNodes.select{|n|
		   row = @vND.getNodesTableRowForNode(n)
		   if !@testColumnNumber.nil?
		      (row & testColumnNodes).size != 0
		   else
		      row.size != 0
		   end
		}
		
		learnNodeItemNumber = getSetupNodeVal("setupIterator").to_i
		learnNodeItemNumber = learnNodeItemNumber % learnColumnSelectedNodes.size
		learnNode = learnColumnSelectedNodes[learnNodeItemNumber]
		p "learnNodeItemNumber: " + learnNodeItemNumber.to_s
		
		setupLearnNode = placeLearnNode(learnNode)
		
		if !@testColumnNumber.nil?
		   goalTestNode = (testColumnNodes & @vND.getNodesTableRowForNode(learnNode)).first
		   buildTestTable(goalTestNode, testColumnNodes, learnNodeItemNumber, additionalTestColumnsNodes)
		   writeTestShowLog(@vND.getNodesTableRowForNode(learnNode))
		end
	end
	def placeLearnNode(learnNode)
		additionalLearnColumnsNodes = @additionalLearnColumns.map{|columnNumber|
		   @vND.getColumnNodesByColumnNumber(columnNumber, @tableName)
		}
		if getStudyGroup(learnNode).size == 1
		   group = getStudyGroup(learnNode)[0]
		   newGroup = group.duplicate()
		   position = VUE.getActiveViewer().getLastMousePressMapPoint();
		   newGroup.x = position.getX() + @learnItemX
		   newGroup.y = position.getY() + @learnItemY
		   newGroup.getMetadataList().add("http://vue.tufts.edu/vue.rdfs#none", @setupNodesKeywordName)
		   newGroup.getMetadataList().add("http://vue.tufts.edu/vue.rdfs#none", "learnObject")
		   newGroup.getMetadataList().add("http://vue.tufts.edu/vue.rdfs#none", "rootNode: " + learnNode.label)
		   newGroup.getMetadataList().add("http://vue.tufts.edu/vue.rdfs#none", "rootNodeId: " + learnNode.id.to_s)
		   VUE.getActiveViewer().getDropFocal().pasteChild(newGroup);
		   addAdditionalColumns(learnNode, newGroup, @learnItemX, @learnItemY, additionalLearnColumnsNodes, @additionalLearnColumnsStepX, @additionalLearnColumnsStepY, @testAdditionalColumnsSide )
		   return newGroup
		else
		   node = Utils.duplicateAndPlaceNode(learnNode, @learnItemX, @learnItemY)
		   node.getMetadataList().add("http://vue.tufts.edu/vue.rdfs#none", @setupNodesKeywordName)
		   node.getMetadataList().add("http://vue.tufts.edu/vue.rdfs#none", "learnObject")
		   node.getMetadataList().add("http://vue.tufts.edu/vue.rdfs#none", "learnNodeId: " + learnNode.id.to_s)
		   addAdditionalColumns(learnNode, nil, @learnItemX, @learnItemY, additionalLearnColumnsNodes, @additionalLearnColumnsStepX, @additionalLearnColumnsStepY, @learnAdditionalColumnsSide )
		   return node
		end
	end
	def buildTestTable(goalTestNode, testNodes, testNumber, additionalTestColumnsNodes)
		itemsInTableSize = (@testTableSize[0] + 1) * (@testTableSize[1] + 1)
		selectedTestNodes = (testNodes - [goalTestNode]).take(itemsInTableSize - 1) + [goalTestNode]
		selectedTestNodes= shuffleList(selectedTestNodes, testNumber)
		testNodeId = 0
		(0..@testTableSize[0]).each{|columnNumber|
		   (0..@testTableSize[1]).each{|rowNumber|
		      x = @testTableX + @testTableStepX*columnNumber
		      y = @testTableY + @testTableStepY*rowNumber
		      testNode = selectedTestNodes[testNodeId]
		      newGroup = nil
		      if getStudyGroup(testNode).size == 1
		         group = getStudyGroup(testNode)[0]
		         newGroup = group.duplicate()
		         position = VUE.getActiveViewer().getLastMousePressMapPoint();
		         newGroup.x = position.getX() + x
		         newGroup.y = position.getY() + y
		         newGroup.getMetadataList().add("http://vue.tufts.edu/vue.rdfs#none", @setupNodesKeywordName)
		         newGroup.getMetadataList().add("http://vue.tufts.edu/vue.rdfs#none", "rootNode: " + testNode.label)
		         newGroup.getMetadataList().add("http://vue.tufts.edu/vue.rdfs#none", "rootNodeId: " + testNode.id.to_s)
		         VUE.getActiveViewer().getDropFocal().pasteChild(newGroup);
		      else
		         node = Utils.duplicateAndPlaceNode(testNode, x, y)
		         node.getMetadataList().remove(0)
		         node.getMetadataList().add("http://vue.tufts.edu/vue.rdfs#none", @setupNodesKeywordName)
		         node.getMetadataList().add("http://vue.tufts.edu/vue.rdfs#none", "testNodeId: " + testNode.id.to_s)
		      end
		      addAdditionalColumns(testNode, newGroup, x, y, additionalTestColumnsNodes, @additionalTestColumnsStepX, @additionalTestColumnsStepY, @testAdditionalColumnsSide )
		      testNodeId += 1
		   }
		}
	end
	def addAdditionalColumns(mainNode, mainGroup, x, y, additionalColumnsNodes, aCStepX, aCStepY, side)
		currentTableRow = @vND.getNodesTableRowForNode(mainNode)
		lastPositionX = lastPositionXForAdditionalColumns(mainNode, mainGroup, x, side)
		additionalColumnsNodes.each_with_index{|nodesColumn, index|
		   additionalNode = currentTableRow & nodesColumn
		   additionalNode.each{|n|
		      stepX = aCStepX
		      if n.label.start_with?("rootNode_")
		         group = getStudyGroup(n)[0]
		         newGroup = group.duplicate()
		         positionX = itemPositionXWithStepForAdditionalColumns(newGroup, lastPositionX, stepX, side)
		         position = VUE.getActiveViewer().getLastMousePressMapPoint();
		         newGroup.x = position.getX() + positionX
		         newGroup.y = position.getY() + y + aCStepY
		         newGroup.getMetadataList().add("http://vue.tufts.edu/vue.rdfs#none", @setupNodesKeywordName)
		         newGroup.getMetadataList().add("http://vue.tufts.edu/vue.rdfs#none", "rootNode: " + testNode.label)
		         VUE.getActiveViewer().getDropFocal().pasteChild(newGroup);
		         positionX = itemPositionXWithItemWidthForAdditionalColumns(positionX, newGroup, side)
		      else
		         positionX = itemPositionXWithStepForAdditionalColumns(n, lastPositionX, stepX, side)
		         node = Utils.duplicateAndPlaceNode(n, positionX, y + aCStepY)
		         if n.label.start_with?("jmp: ")
		            label = n.label.gsub("jmp: ", "")
		            node.label = label
		         end
		         if n.label == "insp"
		            node.x = node.x + 1500
		            node.y = node.y + 330
		         end
		         node.getMetadataList().remove(0)
		         node.getMetadataList().add("http://vue.tufts.edu/vue.rdfs#none", @setupNodesKeywordName)
		         positionX = itemPositionXWithItemWidthForAdditionalColumns(positionX, node, side)
		      end
		      lastPositionX = positionX
		   }
		}
	end
	def lastPositionXForAdditionalColumns(mainNode, mainGroup, x, side)
		lastPositionX = x
		if !mainGroup.nil?
		   if side == "right"
		      lastPositionX += mainGroup.getWidth()
		   elsif side == "left"
		   end
		else
		   if side == "right"
		      lastPositionX += mainNode.getWidth()
		   elsif side == "left"
		   end
		end
		lastPositionX
	end
	def itemPositionXWithStepForAdditionalColumns(item, lastPositionX, stepX, side)
		positionX = nil
		if side == "right"
		   positionX = lastPositionX + stepX
		elsif side == "left"
		   positionX = lastPositionX - item.getWidth() - stepX
		end
		positionX
	end
	def itemPositionXWithItemWidthForAdditionalColumns(positionX, item, side)
		if side == "right"
		   positionX += item.getWidth()
		elsif side == "left"
		end
		positionX
	end
	def getStudyGroup(node)
		studyGroups = node.getOutgoingLinks().select{|l|
		   l.label == "g"
		}.map{|l| l.getTail() }
		studyGroups
	end
	def buildSetupNodes()
		allNodes = @vND.allNodes
		setupNodes = LWComponentKeywords.selectNodesByKeyword(@setupNodesKeywordName, allNodes)
		
		existentSetupIteratorNode = setupNodes.select{|n| n.label.start_with?("setupIterator") }
		
		setupIteratorLabel = "setupIterator: 0"
		setupIteratorNode = nil
		
		if !existentSetupIteratorNode.nil? && existentSetupIteratorNode.size == 1
		   setupIteratorNode = existentSetupIteratorNode.first
		   setupIteratorLabel = setupIteratorNode.label
		   value = setupIteratorLabel.split(": ").last.to_i
		   setupIteratorLabel = "setupIterator: " + (value + 1).to_s
		end
		
		descendants = VUE.getActiveMap().getAllDescendents().select{|n|
		   n.getMetadataList().getMetadata().select{|m|
		      m.getValue() == @setupNodesKeywordName
		   }.size > 0
		}.each{|d| @vND.allNodes  = @vND.allNodes - [d]}.each{|d| d.delete() }
		setupNodes.each{|n| n.delete() }
		
		setupIteratorNode = Utils.makeAndPlaceNode(setupIteratorLabel, 0, @setupY)
		@vND.allNodes << setupIteratorNode
		setupIteratorNode.getMetadataList().add("http://vue.tufts.edu/vue.rdfs#none", @setupNodesKeywordName)
	end
	def getSetupNodeVal(setupNodeName)
		allNodes = @vND.allNodes
		setupNodes = LWComponentKeywords.selectNodesByKeyword(@setupNodesKeywordName, allNodes)
		setupNode = setupNodes.select{|n| n.label.start_with?(setupNodeName) }.first
		setupNodeLabel = setupNode.label
		value = setupNodeLabel.split(": ").last
		value
	end
	def shuffleList(list, step)
		newList = []
		sO = @shuffleOrder + [1]*step
		sO.each{|o|
		   list.each_with_index {|l, index|
		      if index.odd?
		         newList = [l] + newList
		      else
		         newList = newList + [l]
		      end
		   }
		   newList.reverse! if o == 1
		   list = newList
		   newList = []
		}
		list
	end
	def writeTestShowLog(tableRowNodes)
		testShowLogNode = nil
		
		tableRowNodes.each{|n|
		   testShowLogNode = n if n.label == @testShowLogNodeLabel
		}
		
		return if testShowLogNode.nil?
		
		oldLabel = Utils.getTextNodeLabel(testShowLogNode)
		
		date = "#" + Time.new.strftime("%Y-%m-%d %H:%M:%S")
		newLabel = oldLabel + " " + date
		
		Utils.setTextNodeLabel(testShowLogNode, newLabel)
	end
	def writeTestCheckLog(tableRowNodes, checkResult)
		testCheckLogNode = nil
		tableRowNodes.each{|n|
		   testCheckLogNode = n if n.label == @testCheckLogNodeLabel
		}
		return if testCheckLogNode.nil?
		oldLabel = Utils.getTextNodeLabel(testCheckLogNode)
		date = "#" + checkResult.to_s + " " + Time.new.strftime("%Y-%m-%d %H:%M:%S")
		newLabel = oldLabel + " " + date
		Utils.setTextNodeLabel(testCheckLogNode, newLabel)
	end
	def checkAnswer(object)
		allNodes = VUE.getActiveMap().getAllNodesIterator().map{|n| n}
		setupNodes = LWComponentKeywords.selectNodesByKeyword(@setupNodesKeywordName, allNodes)
		gradeNodes = LWComponentKeywords.selectNodesByKeyword(@gradeNodeKeyword, setupNodes)
		gradeNodes.each{|n| n.delete() }
		learnColumnNodes = @vND.getColumnNodesByColumnNumber(@learnColumnNumber, @tableName)
		testColumnNodes = @vND.getColumnNodesByColumnNumber(@testColumnNumber, @tableName)
		check = nil
		testNode = nil
		learnNode = nil
		if !object.instance_of?(LWNode)
		   rootAnswerNodeId = object.getMetadataList().getMetadata().select{|m|
		      m.getValue().start_with?("rootNodeId: ")
		   }.map{|m| m.getValue().split("rootNodeId: ").last}.first
		   testNode = testColumnNodes.select{|n|
		      n.id.to_s == rootAnswerNodeId.to_s
		   }.first
		else
		   answerNodeId = object.getMetadataList().getMetadata().select{|m|
		      m.getValue().start_with?("testNodeId: ")
		   }.map{|m| m.getValue().split("testNodeId: ").last}.first
		   testNode = testColumnNodes.select{|n|
		      n.id.to_s == answerNodeId.to_s
		   }.first
		end
		learnObject = VUE.getActiveMap().getAllDescendents().select{|o|
		   setup = o.getMetadataList().getMetadata().select{|m|
		      (m.getValue() == @setupNodesKeywordName )
		   }
		   learnObject = o.getMetadataList().getMetadata().select{|m|
		      (m.getValue() == "learnObject" )
		   }
		   setup.size > 0 && learnObject.size > 0
		}.first
		p learnObject.label
		if !learnObject.instance_of?(LWNode)
		   rootGoalLearnNodeId = learnObject.getMetadataList().getMetadata().select{|m|
		      m.getValue().start_with?("rootNodeId: ")
		   }.map{|m| m.getValue().split("rootNodeId: ").last}.first
		   learnNode = learnColumnNodes.select{|n|
		      n.id.to_s == rootGoalLearnNodeId.to_s
		   }.first
		else
		   goalLearnNodeId = learnObject.getMetadataList().getMetadata().select{|m|
		      m.getValue().start_with?("learnNodeId: ")
		   }.map{|m| m.getValue().split("learnNodeId: ").last}.first
		   learnNode = learnColumnNodes.select{|n|
		      n.id.to_s == goalLearnNodeId.to_s
		   }.first
		end
		p learnNode
		learnNodeRow = @vND.getNodesTableRowForNode(learnNode)
		check = learnNodeRow.include?(testNode)
		
		writeTestCheckLog(learnNodeRow, check)
		addGrade(check)
	end
	def addGrade(check)
		grade = ""
		if check
		   grade = "Правильно. Молодец"
		else
		   grade = "Ошибка"
		end
		gradeNode = Utils.makeAndPlaceNode(grade , @gradeX, @gradeY)
		gradeNode.getMetadataList().add("http://vue.tufts.edu/vue.rdfs#none", @setupNodesKeywordName)
		gradeNode.getMetadataList().add("http://vue.tufts.edu/vue.rdfs#none", @gradeNodeKeyword)
	end
end
class StudyNodeGroup
	attr_accessor :conf,
	:schemaKeyword,
	:vND,
	:setupNodesKeywordName,
	:rootNode,
	:group
	def initialize(schemaKeyword)
		@schemaKeyword = schemaKeyword
	end
end

# vim: tabstop=4 softtabstop=0 noexpandtab shiftwidth=4 number
