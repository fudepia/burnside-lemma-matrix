%%% Compile Command
% Document: ptex2pdf -u -l -ot "-synctex=1 -interaction=nonstopmode -file-line-error-style" $*
% Haskell: ghc -dynamic

\documentclass[11pt,a4paper,dvipdfmx]{ujarticle}
\usepackage[margin=24mm]{geometry}
\usepackage{preamble-jp}


\author{楊記綱}
\title{Extended Application of Burnside's Lemma to Higher Dimension using Matrix and Linear Transformation}
%\和暦
\西暦
 
\ttfamily

\begin{document}

\maketitle

\begin{abstract} % http://www.info.kochi-tech.ac.jp/mfukumot/Lecture/CS1/LaTeX/LaTeX_command.html
\begin{code}
module Burnside where
\end{code}
針對清大課程Burnside's Lemma去從線性轉換與矩陣、向量的角度去做延伸。令嘗試將此想法推廣到更高維度、非正多面體與較複雜之正多面體。
\end{abstract}

\tableofcontents
% TOC doesn't work well with customized Appendix title, don't know why
\newpage
% \pagebreak

\begin{comment}
\begin{code}
import Data.List
\end{code}
\end{comment}

\section*{How to Read}
\addcontentsline{toc}{section}{How to Read}

\subsection{Defining Notations}
\addcontentsline{toc}{subsection}{Defining Notations}

\subsubsection{Vector}
All vectors within this document (no matter if it's in Haskell code or TeX equations) refers to column vectors (even if it's written in style of row vector).

\subsubsection{Matrix}

Within this document, we'll often use matrix as a denotation for an ordered-list of vectors.

\begin{equation*}
[v_1, \dots, v_k] = \begin{bmatrix}
\begin{pmatrix}
v_{1, 1} \\ \vdots \\ v_{1, n}
\end{pmatrix} & \dots & 
\begin{pmatrix}
v_{k, 1} \\ \vdots \\ v_{k, n}
\end{pmatrix}
\end{bmatrix} = \begin{bmatrix}
v_{1, 1} & \dots & v_{k, 1} \\
\vdots & \ddots & \vdots \\
v_{1, n} & \dots & v_{k, n}
\end{bmatrix}
\end{equation*}
\begin{center}
$k=$amount of vectors, $n=$vectors' dimension
\end{center}

And since we're treating matrix as a list (or a set, since it's guaranteed that each vector within it is unique\footnote{The sole reason I still prefer to call it a list instead of a set is basically due to its ordered nature. Cause in math, sets are unordered, but here it's critical to main that order-ness, as we're identifying faces through that order.}), for simplicity, we'll be using following two expression quite often.

\begin{subequations}
\begin{equation}
\text{column vector $v$ that exists in M: }v\in{M}
\end{equation}
\begin{equation}
\text{for all column vector $v$ in M: }\forall{v}\in{M}
\end{equation}
\end{subequations}

\newpage


\section{Brief Introduction to Matrix and Linear Transformation}
So what does matrix in linear transformation means? Well, for any $n\times n$ matrix, you could think of each column as representing each axis' unit vector's position after the transformation. So for example:
\begin{align}
  \text{Let }&T=
  \begin{bmatrix}
    a & b & c \\
    d & e & f \\
    g & h & i
  \end{bmatrix}\\ \text{ means, shifting }&\hat{i}=\begin{bmatrix}1\\0\\0\end{bmatrix},\hat{j}=\begin{bmatrix}0\\1\\0\end{bmatrix},\hat{k}=\begin{bmatrix}0\\0\\1\end{bmatrix}\text{ to }\\
  &\hat{i}'=\begin{bmatrix}a\\d\\g\end{bmatrix},\hat{j}'=\begin{bmatrix}b\\e\\h\end{bmatrix},\hat{k}'=\begin{bmatrix}c\\f\\i\end{bmatrix}
\end{align}
Hence by these definitions we could conclude that:
\begin{thm}[最少資料量]\label{data}
  For any object within n-Dimensional space, by specifying n-Surfaces' location could unique identify an object's orientation.
\end{thm}

\section{Describing Object's State}

\begin{dfn}[Structure-Matrix]
To descibe an object's current orientation, we'll use a set of vectors (which is collected into a matrix).
\end{dfn}

 For example, a $2\times 2$ square could be denoted by two 2-D vectors (aka a $2\times 2$ matrix) like following:

\begin{multicols}{2}

\null \vfill
\begin{equation}
M = \begin{bmatrix}
    x_1 & x_2 \\
    y_1 & y_2
  \end{bmatrix}
\end{equation}
\vfill \null

\columnbreak

% \begin{figure}[!h]\centering
\input{2x2-structure.tikz}
% \end{figure}

\end{multicols}


in which we could clearly see by giving two 2-D vectors, we could rigidly define our 4 different squadron (in counterclockwise fashion).

\hr

Or like a cube with 6 faces to color, we could denote it as following:
\begin{equation}
\text{令所有面之向量之列表}L=
\begin{bmatrix}
  0 & 1 & 0  & -1 & 0 & 0  \\
  1 & 0 & -1 & 0  & 0 & 0  \\
  0 & 0 & 0  & 0  & 1 & -1 \\
\end{bmatrix}
\end{equation}

\begin{sidenote}{On Duplicated Information}
% QUESTION: Is it possible for "Linear Transformation" to break such structure?
One dangerous thing about duplicated info is that you might break structural relationship. As you may have noticed, the matrix above that's being used to denote a cube contains vectors that can be calculated base from others. If we number them from left to right you can see that

\begin{subequations}
\begin{equation}
v_3=-v_1
\end{equation}
\begin{equation}
v_4=-v_2
\end{equation}
\begin{equation}
v_6=v_1\times v_2
\end{equation}
\begin{equation}
v_5=-v_6
\end{equation}
\end{subequations}

Which meant we only need 2 vectors\footnote{Since our matrix represents an ordered-list, we won't need the third vector to determine orientation. ($[v_1, v_2]\neq[v_2, v_1]$)} to denote a cube. But since in Burnside's Lemma, we're only considering rotation and reflection, leaving duplicated information won't make any difference (except adding some computational time), as rotation and reflection simply won't break an object's structure.

Yet this is still something you should keep in mind, if you're brute forcing all possible outcome by simply shuffling orders of those vectors (instead of using matricies to calculate them). Since you're not using matrix, it'll be your responsibility to ensure those 4 condition listed above are satisfied (suppose you use our initial $L$).
\end{sidenote}

\section{Operations upon Object's State}

Now we can apply transformations onto these vectors. But what could be counted as a valid transformation?

Well, since we already know linear transformation wouldn't break the structure of the object, the only other condition to met is for a transformation to maintain the outline of the object. Or more precisely:

\begin{dfn}[Shuffle Transformation]
\begin{equation}
\forall{v\in T M}\left(v\in \left\{v \,|\, v \in M \right\}\right)
\end{equation}
\end{dfn}

\begin{code}
-- Check if no new vectors are created and no old vectors are altered
validVectors1 :: Matrix -> Matrix -> Bool
--               sample    subject   result
validVectors1 (Matrix s) (Matrix x) = sort s' == sort x'
                                     where s' = nub s
                                           x' = nub x
\end{code}

\section{Collection of all valid Transformations}
當我們在談到旋轉一物體的時候我們可以將其總結成：
\begin{equation}
  \mathbb{T}=\{T \mid T \cdot x\in \mathbb{X}, x\in\mathbb{X}\}
\end{equation}
其中$\mathbb{T}$代表所有合法的$n\times n$矩陣使得作用於$\mathbb{X}$中任意元件會得結果$T\cdot x=x'\ni x,x'\in\mathbb{X}$。那也就是換成講義裡的記號$|G|=\#\mathbb{T}$。
\subsection{Calculate \texorpdfstring{$\#\mathbb{T}$}{\#T}}
還記得在定理\ref{data}中所說的最少資料量嗎？現在對我們的n維物體來標示各種orientation的話，舉$\mathbb{R}^3$物體為例，可靠標記其中三個面的方位即可。所以（為了後續計算方便）我們就永遠選相鄰的三個邊，以數對$(A,B,C)$表示\footnote{本文中所有表示面之數，皆為向量，且皆由原點指向該面之重心}。那現在令所有可能的數對之集合：
\begin{equation}
  \mathbb{P}=\{(D,E,F)\mid \angle DOE = \angle AOB, \angle{DOF}=\angle{AOC}, \angle{EOF}=\angle{BOC}\}
\end{equation}
其中我們叫這保角性質我們所選之數對$(A,B,C)$的Structure，而單純允許旋轉而不允許映射的情況下，這是一個該被確保的Structure。另外須注意這Structure是有方向之分的，通常$A, B, C$採逆時鐘排列（從原點向外指，右手方向）。

那現在定義完$\mathbb{P}$，要計算旋轉方式就簡單多了。首先我們知道$\forall P\in\mathbb{P}\, , \exists T\in\mathbb{T}\ni T\cdot(A,B,C)=P$（其中$T\cdot (A,B,C)=(TA,\, TB,\, TC)$所以$\#\mathbb{P}=\#\mathbb{T}=|G|$。而至於$\mathbb{P}$則可用排列組合推出，對立方體舉例：
\begin{equation*}
\begin{gathered}
  \text{先任意選一面}A\\
  \text{再選一面相鄰$A$的面}B\\
  \text{最後再選唯一一個在這兩面逆時鐘方向的面}C\\
  \text{得$\#\mathbb{P}=C^6_1\times C^4_1 \times C^1_1=24$}
\end{gathered}
\end{equation*}
對正四面體亦同：
\begin{equation*}
\begin{gathered}
  \text{先任意選一面}A\\
  \text{再選一面相鄰$A$的面}B\\
  \text{最後再選唯一一個在這兩面逆時鐘方向的面}C\\
  \text{得$\#\mathbb{P}=C^4_1\times C^3_1 \times C^1_1=12$}
\end{gathered}
\end{equation*}

或者嘗試將它Generalized對任意正多面體：
\begin{equation}
  \text{$|G|=$（面數）$\times$（一面的邊數、一面相鄰的面數）}
\end{equation}

\subsection{Calculate \texorpdfstring{$\mathbb{T}$}{T}}
那算完他的數量，我們有沒有從它回推$\mathbb{T}$裡面的內容呢？有的（至少用電腦算式簡單的），我們甚至能算出他的組數（那個$k^n$的$n$）一樣拿立方體舉例：
\begin{subequations}
  \begin{equation}
    \text{令所有面之向量之列表}L=
    \begin{bmatrix}
      0 & 1 & 0  & -1 & 0 & 0  \\
      1 & 0 & -1 & 0  & 0 & 0  \\
      0 & 0 & 0  & 0  & 1 & -1 \\
    \end{bmatrix}
  \end{equation}
  \begin{equation}
    \text{舉例取轉換}T=
    \begin{bmatrix}
      0 & -1 & 0 \\
      1 & 0  & 0 \\
      0 & 0  & 1
    \end{bmatrix}
  \end{equation}
  \begin{equation}
      \text{得}TL=
    \begin{bmatrix}
      -1 & 0 & 1 & 0  & 0 & 0  \\
      0  & 1 & 0 & -1 & 0 & 0  \\
      0  & 0 & 0 & 0  & 1 & -1
    \end{bmatrix}
  \end{equation}
\end{subequations}
其中我們可看到，縱列1$\sim$4向右位移了一格，而5,6不變。因此可得對變換$T$（z軸左手旋轉90度）可分成三組，也就是對$L, TL$做disjoint set後數他的數量。

就此我們就可以算出他的塗色可能性了。

\begin{code}
listTracks :: Matrix -> Matrix -> [[Int]]
listTracks = curry$joinTrack.uncurry trackShift

trackShift :: Matrix -> Matrix -> [(Int, Int)]
trackShift (Matrix von) (Matrix zu) = map (search von') zu'
           where von' = zip [1..length von] von
                 zu'  = zip [1..length zu]  zu
                 search xs (id, x) = (fst.head$filter (\(_, x') -> x'==x) xs, id)

joinTrack :: [(Int, Int)] -> [[Int]]
joinTrack xs = nub $ map ((nub.sort) . makeChain xs) xs
--                         ^^^ Btw, using `nub` won't break the chain (aka it'll only remove first/last element)
makeChain :: [(Int, Int)] -> (Int, Int) -> [Int]
makeChain xs (init, termin)
                | termin /= x = termin:init:makeChain xs (x, termin)
                | otherwise = [init, termin]
                 where x  = fst $ xs!!(init-1)
\end{code}

\section{Extend Research Topics（未寫）}
\subsection{2x2魔術方塊}

To be honest, the main reason I'm introducing matrix/linear transformation into Burnside's Lemma is purely due to its elegancy. By abstracting all the ideas of motion and how a set of faces needs to be the same color into matrix, makes it very easy to solve using computer (at least I hope so, originally). But it turns out I'm only halfway right. It's true we could find all possible transformation more confidently either by brute forcing or 排列組合 with some idea I've developed through this theory, but still there's still some parts we have to hack it through. A minor one will be that we'll have to compare two matrices and then group them by who've swapped to whose slot, but that's still acceptable as we're able to write program to do that. But when we enter the realm of Rubik's Cube, we're faced with the greatest obstacle throughout this project.

\begin{Q}
How do we rotate one layer of the Rubik's Cube, while leaving the other layers still?
\end{Q}

I'm sorry to say it, but now we're going to enter the \textbf{\textit{``programming''}} realm. Why? Because the best method I could think of is just group layers, then apply transformation seperately.

Well, with our strategy decided, let's start modeling the Rubik's Cube first.

\begin{code}
type Rubiks2x2 = (Matrix, Matrix)
--                |       ^ Each Faces
--                |> Each Block
{- For Rubiks2x2 P F:
P = [ Corners*8   , Edges*12   ]
F = [ Corners*8*3 , Edges*12*2 ]
-}
\end{code}

The way I model 2x2 Rubik's Cube is by first giving a position vector $p_i$ and then a facing vector $f_i$ which tells you which direction is the first face facing.

\begin{subequations}
\begin{equation}
P = \begin{bmatrix}
p_1 & \dots & p_8
\end{bmatrix},\,
\text{each component of }p_i\text{ is either 1 or -1}
\end{equation}
\begin{equation}
F = \begin{bmatrix}
f_1 & \dots & f_8
\end{bmatrix},\,
f_i\text{ is one of the 6 different (directional) unit vector}
\end{equation}
\end{subequations}

And know with $(p_i, f_i)$ we could denote any block we want, where we can then give a list of 3 colours (order-sensitive) which will be coloured counterclockwise.\footnote{Since Haskell only support variables' name starting with lower case, we'll have to follow the rule. So just keep in mind that \icode{p2x2} meant $P$, and \icode{f2x2} meant $F$.}

\begin{code}
attachID :: [[Int]] -> [[Int]]
attachID xs = map (uncurry (++)) $ zip (map singleton [1..length xs]) xs
p2x2 = Matrix $ attachID $
       map ([3]++) $
       (:) <$> [1, -1] <*>
       ((\a b -> [a, b]) <$> [1, -1] <*> [1, -1])
f2x2 = Matrix $ attachID $ concatMap genFace $ stripMatrix p2x2
twoByTwo = (p2x2, f2x2)
\end{code}

\begin{code}
genFace :: [Int] -> [[Int]]
genFace (i:g:x:y:z:_) = map (i:) $ (fx x) ++ (fy y) ++ (fz z)
                   where fx v | v==1=[right] | v==(-1)=[left  ] | otherwise = []
                         fy v | v==1=[rear ] | v==(-1)=[front ] | otherwise = []
                         fz v | v==1=[top  ] | v==(-1)=[bottom] | otherwise = []
\end{code}

\begin{code}
-- Some shortcut for readability
top    = [ 0,  0,  1]
bottom = [ 0,  0, -1]
right  = [ 1,  0,  0]
left   = [-1,  0,  0]
front  = [ 0, -1,  0]
rear   = [ 0,  1,  0]
\end{code}

\subsection{Getting Layers}

\begin{code}
-- Grouping of 2x2 Rubik's Cube
getLayer :: Vector -> Rubiks2x2 -> Rubiks2x2
getLayer uv (Matrix p, Matrix f) = (Matrix (corner++edge), Matrix (f'))
               where f' = filter (\(i:d:x) -> x==uv) f
                     -- (fC, fE) = span (\x -> 5 == length x) f'
                     corner = map ((p !!) . (\(_:g:_) -> g-1)) f'--fC
                     edge = []
                     --edge   = map (((p !!).(8 +)).flip div 2.fst.(\(id, x)->(id-24, x))) fE
-- TODO: Impl for 3x3
\end{code}

\subsection{Join Everything Together}

\begin{code}
idn :: Int -> Vector
idn n
    | n < 1 = [1]
    | otherwise = 0:idn (n-1)
padU :: Matrix -> Matrix
padU (Matrix m) = Matrix $ (1:replicate (length m) 0) : map (0:) m
\end{code}

\begin{code}
rot90Z=Matrix [[0,1,0], [-1,0,0], [0,0,1]]
\end{code}

\begin{code}
patchLayer' :: Matrix -> Matrix -> Matrix
patchLayer' x (Matrix []) = x
patchLayer' (Matrix x) (Matrix (t:m)) = patchLayer' (Matrix (a++[t]++b)) (Matrix m)
                where (a, b') = break (\(i:_) -> i==head t) x
                      b = tail b'
patchLayer :: Rubiks2x2 -> Rubiks2x2 -> Rubiks2x2
patchLayer (a, b) (p, q) = (patchLayer' a p, patchLayer' b q)
\end{code}

\begin{code}
apply :: Matrix -> Vector -> Rubiks2x2 -> Rubiks2x2
--       Transform Layer     Input        Output
apply t v x = patchLayer x (pt*a, pt*b)
           where (a, b) = getLayer v x
                 pt = padU.padU $ t
-- TODO: Check result!!
\end{code}

\subsubsection{Proof of Completeness}
% TODO:

% \subsection{非正多面體}
% \subsection{高維物體}

% \subsection{3x3魔術方塊}
% \begin{code}
% blockType = flip (!!) 4 -- 3 for corner, 2 for edge
% \end{code}
% \begin{comment}
% \begin{code}
% p3x3 = Matrix [
%     [ 1, -1,  1, 3], [ 1,  1,  1, 3], [-1,  1,  1, 3], [-1, -1,  1, 3],
%     [ 1, -1, -1, 3], [ 1,  1, -1, 3], [-1,  1, -1, 3], [-1, -1, -1, 3],
%     [ 1,  0,  1, 2], [ 0,  1,  1, 2], [-1,  0,  1, 2], [ 0, -1,  1, 2],
%     [ 1, -1,  0, 2], [ 1,  1,  0, 2], [-1,  1,  0, 2], [-1, -1,  0, 2],
%     [ 1,  0, -1, 2], [ 0,  1, -1, 2], [-1,  0, -1, 2], [ 0, -1, -1, 2] ]
% f3x3 = Matrix $ concat [
%     [top, front, right], [top, right, rear], [top, rear, left], [top, right, front],
%     [bottom, right, front], [bottom, rear, right], [bottom, left, rear], [bottom, front, right],
%     [top, right], [top, rear], [top, left], [top, front],
%     [front, right], [right, rear], [rear, left], [left, front],
%     [bottom, right], [bottom, rear], [bottom, left], [bottom, front] ]
% threeByThree = (p3x3, f3x3)
% \end{code}
% \end{comment}








\newpage
\appendix

\section{Matrix}

\begin{code}
type Vector = [Int]
vector :: [Int] -> Matrix
vector a = Matrix [a]

newtype Matrix = Matrix [[Int]]

stripMatrix :: Matrix -> [[Int]]
stripMatrix (Matrix x) = x
\end{code}

\begin{code}
instance Show Matrix where
    show (Matrix [x:xs])
                    | null xs = "[" ++ show x ++ "]"
                    | otherwise = "[" ++ show x ++ "]\n" ++ show (Matrix [xs])
    show (Matrix rows)
           | length (head rows) > 1  = "[" ++ intercalate ", " (map (show.head) rows) ++ "]\n"
                                     ++ show (Matrix (map tail rows))
           | otherwise = "[" ++ intercalate ", " (map (show.head) rows) ++ "]"
dumpMatrix = print.stripMatrix
\end{code}

\begin{code}
a = Matrix [[1,2],[2,4],[2,0],[2,2]]
b = Matrix [[2,4],[2,0],[1,2],[2,2]]
\end{code}

\begin{code}
concatM :: Matrix -> Matrix -> Matrix
concatM (Matrix x) (Matrix y) = Matrix $ x ++ y
diagFlip' :: [[a]] -> [[a]]
diagFlip' xs
           | length (head xs) > 1 = map head xs : diagFlip' (map tail xs)
           | otherwise = [map head xs]
diagFlip :: Matrix -> Matrix
diagFlip (Matrix xs) = Matrix $ diagFlip' xs
\end{code}

\begin{code}
instance Num Matrix where
    (Matrix [xs]) + (Matrix [ys]) = Matrix [zipWith (+) xs ys]
    Matrix (x:xs) + Matrix (y:ys) = concatM (Matrix [zipWith (+) x y]) (Matrix xs + Matrix ys)
    (Matrix []) + a@(Matrix _) = a
    a@(Matrix _) + (Matrix []) = a
    x * (Matrix ys) = Matrix $ map f ys
                     where f y = map (sum.zipWith (*) y) xs'
                           (Matrix xs') = diagFlip x
\end{code}


\section{Sage Graphics}

\subsection{2x2 Rubik's Cube}

\begin{sageblock}
def colorRect3D(x, c, l, f): # f: 0 (xy), 1 (xz), 2 (yz)
    x = vector(x)
    if f == 0:
        sv1 = vector((-l, 0, 0))
        sv2 = vector((0, -l, 0))
    elif f == 1:
        sv1 = vector((-l, 0, 0))
        sv2 = vector((0, 0, -l))
    elif f == 2:
        sv1 = vector((0, -l, 0))
        sv2 = vector((0, 0, -l))
    Gph = Graphics()
    Gph += polygon3d([x, x+sv1, x+sv1+sv2, x+sv2])
    return Gph
\end{sageblock}

\begin{sageblock}
def colorBlock(p, f, c):
    Gph = Graphics()
    baseVector = p * 0.5
    for cl in c:
        if f[2]!=0:
            Gph += colorRect3D(baseVector, c, 1, 0)
    return Gph
\end{sageblock}

\begin{sageblock}
def plotRubiks2x2(P, F, cs):
    Gph = Graphics()
    for p, f, c in zip(P, F, cs):
        Gph += colorBlock(p, f, c)
    # save3D(Gph) # Comment out if you don't want auto-export
    return Gph
\end{sageblock}

\begin{sageblock}
def save3D(g, n="plot"):
    filename = "/tmp/"+n+".html"
    g.save(filename)
    os.system("sed -i 's/\/usr\/share/..\/usr\/share/g' "+filename)
    print("Plot3D saved to: "+filename)
\end{sageblock}

% Usage: 
%     \iipcode{colorBlock([p]*n, [f]*n, [[(r, g, b)]*3]*n)}

\section{Ternary Operator}
\begin{code}
-- https://wiki.haskell.org/Ternary_operator
data Cond a = a :? a

infixl 0 ?
infixl 1 :?

(?) :: Bool -> Cond a -> a
True  ? (x :? _) = x
False ? (_ :? y) = y
\end{code}

\newpage
\section*{LICENSE}
\addcontentsline{toc}{section}{LICENSE}

\subsection*{Codes}

\subsection*{Documentation}

\end{document}

% https://www.math.kyoto-u.ac.jp/~arai/latex/presen2.pdf
% https://texwiki.texjp.org/?upTeX%2CupLaTeX#p5e56276
% http://otoya8bit.hatenablog.jp/entry/2013/11/28/153226
% Unicode of Double Struck Letters: https://ja.wikipedia.org/wiki/%E9%BB%92%E6%9D%BF%E5%A4%AA%E5%AD%97#%E8%A1%A8%E7%A4%BA%E4%BE%8B

% Another possible way to arrange abstract and TOC
% https://www.isc.meiji.ac.jp/~mizutani/tex/latex_manual/latex.pdf
