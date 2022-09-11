%%% Compile Command
% Document: ptex2pdf -u -l -ot "-synctex=1 -interaction=nonstopmode -file-line-error-style" $*
% Haskell: ghc -dynamic

\documentclass[uplatex,11pt,a4paper,dvipdfmx]{ujarticle}
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
\section{Properties}
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
      0 & 1 & 0 & -1 & 0 & 0\\
      1 & 0 & -1 & 0 & 0 & 0\\
      0 & 0 & 0 & 0 & 1 & -1\\
    \end{bmatrix}
  \end{equation}
  \begin{equation}
    \text{舉例取轉換}T=
    \begin{bmatrix}
      0 & -1 & 0 \\
      1 & 0 & 0 \\
      0 & 0 & 1
    \end{bmatrix}
  \end{equation}
  \begin{equation}
      \text{得}TL=
    \begin{bmatrix}
      -1 & 0 & 1 & 0 & 0 & 0 \\
      0 & 1 & 0 & -1 & 0 & 0 \\
      0 & 0 & 0 & 0 & 1 & -1
    \end{bmatrix}
  \end{equation}
\end{subequations}
其中我們可看到，縱列1$\sim$4向右位移了一格，而5,6不變。因此可得對變換$T$（z軸左手旋轉90度）可分成三組，也就是對$L, TL$做disjoint set後數他的數量。

就此我們就可以算出他的塗色可能性了。


\begin{comment}
\begin{code}
eqPair :: (Eq a) => (a, a) -> Bool
eqPair (x, y) = x==y
\end{code}
\end{comment}
\begin{code}
disjointSetNum :: Matrix -> Matrix -> Int
disjointSetNum (Matrix a) (Matrix b) = sum $ map fromEnum (map eqPair (zip a b))
\end{code}

\section{Extend Research Topics（未寫）}
\subsection{非正多面體}
\subsection{高維物體}
\subsection{魔術方塊}








\newpage
\appendix

\section{Matrix}

\begin{code}
newtype Matrix = Matrix [[Int]]
vector :: [Int] -> Matrix
vector a = Matrix [a]
\end{code}

\begin{code}
instance Show Matrix where
    show (Matrix [x:xs])
                    | null xs = "[" ++ show x ++ "]"
                    | otherwise = "[" ++ show x ++ "]\n" ++ show (Matrix [xs])
    show (Matrix rows)
           | length (head rows) > 1  = "[" ++ (intercalate ", " (map (show.head) rows)) ++ "]\n"
                                     ++ show (Matrix (map tail rows))
           | otherwise = "[" ++ (intercalate ", " (map (show.head) rows)) ++ "]"
\end{code}

\begin{code}
a = Matrix [[1,2],[2,0]]
b = Matrix [[2,4],[2,0]]
\end{code}

\begin{code}
concatM :: Matrix -> Matrix -> Matrix
concatM (Matrix x) (Matrix y) = Matrix $ x ++ y
diagFlip :: Matrix -> Matrix
diagFlip (Matrix xs)
    | length (head xs) > 1 = concatM (Matrix [map head xs]) (diagFlip (Matrix (map tail xs)))
    | otherwise = Matrix [map head xs]
\end{code}

\begin{code}
instance Num Matrix where
    (Matrix [xs]) + (Matrix [ys]) = Matrix [zipWith (+) xs ys]
    (Matrix (x:xs)) + (Matrix (y:ys)) = concatM (Matrix [zipWith (+) x y]) ((Matrix xs)+(Matrix ys))
    (Matrix []) + a@(Matrix _) = a
    a@(Matrix _) + (Matrix []) = a
    x * (Matrix ys) = Matrix $ map f ys
                     where f y = map (sum.(zipWith (*)) y) xs'
                           (Matrix xs') = diagFlip x
\end{code}


\end{document}

% https://www.math.kyoto-u.ac.jp/~arai/latex/presen2.pdf
% https://texwiki.texjp.org/?upTeX%2CupLaTeX#p5e56276
% http://otoya8bit.hatenablog.jp/entry/2013/11/28/153226
% Unicode of Double Struck Letters: https://ja.wikipedia.org/wiki/%E9%BB%92%E6%9D%BF%E5%A4%AA%E5%AD%97#%E8%A1%A8%E7%A4%BA%E4%BE%8B

% Another possible way to arrange abstract and TOC
% https://www.isc.meiji.ac.jp/~mizutani/tex/latex_manual/latex.pdf
