module GameOfLifeSpec
  ( spec
  ) where

import           GameOfLife
import           Test.Hspec        (Spec, context, describe, it, shouldBe,
                                    shouldMatchList)
import           Test.Hspec.Runner (hspec)

main :: IO ()
main = hspec spec

setMultipleAlive :: [Position] -> Board
setMultipleAlive = foldl (changeStateOfCellAt Living) mkBoard

spec :: Spec
spec =
  describe "Game of Life" $ do
    describe "Next generation rules" $ do
      let livingCell = Living
      let deadCell = Dead
      context "Living Cell" $ do
        it "should die on less than 2 living neighbours" $ do
          nextState livingCell 0 `shouldBe` Dead
          nextState livingCell 1 `shouldBe` Dead
        it "should survive on 2 or 3 living neighbours" $ do
          nextState livingCell 2 `shouldBe` Living
          nextState livingCell 3 `shouldBe` Living
        it "should die on more than 3 living neighbours" $ do
          nextState livingCell 4 `shouldBe` Dead
          nextState livingCell 8 `shouldBe` Dead
      context "Dead Cell" $ do
        it "should stay dead" $ do
          nextState deadCell 1 `shouldBe` Dead
          nextState deadCell 2 `shouldBe` Dead
          nextState deadCell 4 `shouldBe` Dead
        it "should be born on exactly 3 living neighbours" $ nextState deadCell 3 `shouldBe` Living
    describe "Board" $ do
      let emptyBoard = mkBoard
      context "Querying" $ do
        let boardWithOneLivingCell = changeStateOfCellAt Living emptyBoard (1, 1)
        it "should have dead cells initially" $ emptyBoard `stateOfCellAt` (1, 1) `shouldBe` Dead
        it "should allow cell to be set alive" $ boardWithOneLivingCell `stateOfCellAt` (1, 1) `shouldBe` Living
        it "should allow cell to be set to dead" $ do
          let notAliveAnymore = changeStateOfCellAt Dead boardWithOneLivingCell (1, 1)
          notAliveAnymore `stateOfCellAt` (1, 1) `shouldBe` Dead
        it "should memorize position of living cell" $ boardWithOneLivingCell `stateOfCellAt` (0, 0) `shouldBe` Dead
        it "should memorize position of many living cells" $ do
          let boardWithTwoLivingCells = changeStateOfCellAt Living boardWithOneLivingCell (0, 0)
          boardWithTwoLivingCells `stateOfCellAt` (1, 1) `shouldBe` Living
          boardWithTwoLivingCells `stateOfCellAt` (0, 0) `shouldBe` Living
      context "Counting Neighbours" $ do
        it "should count on empty board" $ emptyBoard `countNeighboursOf` (1, 1) `shouldBe` 0
        it "should count on board with living cells" $ do
          let board = setMultipleAlive [(0, 0), (1, 0), (0, 1)]
          board `countNeighboursOf` (1, 1) `shouldBe` 3
        it "should only count adjacent cells" $ do
          let board = setMultipleAlive [(3, 3)]
          board `countNeighboursOf` (1, 1) `shouldBe` 0
        it "should count on board with all neighbours alive" $ do
          let cells = [(0, 0), (1, 0), (2, 0), (0, 1), (2, 1), (0, 2), (1, 2), (2, 2)]
          let board = setMultipleAlive cells
          board `countNeighboursOf` (1, 1) `shouldBe` 8
        it "should not count the cell itself as its neighbour" $ do
          let board = setMultipleAlive [(1, 1)]
          board `countNeighboursOf` (1, 1) `shouldBe` 0
      context "Affected Cells" $ do
        it "should return empty on empty board" $ affectedCellsOn emptyBoard `shouldBe` []
        it "should return all neighbours of living cell" $ do
          let oneLiving = setMultipleAlive [(1, 1)]
          let expected = [(0, 0), (1, 0), (2, 0), (0, 1), (1, 1), (2, 1), (0, 2), (1, 2), (2, 2)]
          affectedCellsOn oneLiving `shouldMatchList` expected
        it "should return all neighbours of 2 distinct living cells" $ do
          let twoLiving = setMultipleAlive [(1, 1), (4, 4)]
          let expected =
                [ (0, 0)
                , (1, 0)
                , (2, 0)
                , (0, 1)
                , (1, 1)
                , (2, 1)
                , (0, 2)
                , (1, 2)
                , (2, 2)
                , (3, 3)
                , (4, 3)
                , (5, 3)
                , (3, 4)
                , (4, 4)
                , (5, 4)
                , (3, 5)
                , (4, 5)
                , (5, 5)
                ]
          affectedCellsOn twoLiving `shouldMatchList` expected
        it "should return all neighbours of 2 adjacent living cells" $ do
          let twoLiving = setMultipleAlive [(1, 1), (2, 2)]
          let expected =
                [ (0, 0)
                , (1, 0)
                , (2, 0)
                , (0, 1)
                , (1, 1)
                , (2, 1)
                , (0, 2)
                , (1, 2)
                , (2, 2)
                , (3, 1)
                , (3, 2)
                , (1, 3)
                , (2, 3)
                , (3, 3)
                ]
          affectedCellsOn twoLiving `shouldMatchList` expected
    describe "Next generation" $ do
      let emptyBoard = mkBoard
      it "should keep empty board empty" $
        nextGenerationOn emptyBoard `shouldBe` emptyBoard
      it "should let single cell die" $ do
        let oneLiving = setMultipleAlive [(1, 1)]
        nextGenerationOn oneLiving `shouldBe` emptyBoard
      it "should keep 2x2 square stable" $ do
        let square2x2 = setMultipleAlive [(0, 1), (1, 1), (0, 2), (1, 2)]
        nextGenerationOn square2x2 `shouldBe` square2x2
      it "should flip 1x3 block" $ do
        let block1x3 = setMultipleAlive [(1, 1), (1, 2), (1, 3)]
        let expected = setMultipleAlive [(0, 2), (1, 2), (2, 2)]
        nextGenerationOn block1x3 `shouldBe` expected
      it "should flip 3x1 block" $ do
        let block3x1 = setMultipleAlive [(0, 2), (1, 2), (2, 2)]
        let expected = setMultipleAlive [(1, 1), (1, 2), (1, 3)]
        nextGenerationOn block3x1 `shouldBe` expected
