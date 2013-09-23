<TeXmacs|1.0.7.14>

<style|generic>

<\body>
  <\doc-data|<doc-title|Algorithms>|<doc-subtitle|HW1 -
  2B>|<doc-author-data|<author-name|Alan Rosenthal>>|<\doc-date>
    <date>
  </doc-date>>
    \;

    \;
  </doc-data>

  <\enumerate-numeric>
    <\verbatim-code>
      FindSeam(D,m,n)

      <item>let B[1..m][1..n] and C[1..(m-1)][1..n] be a new table

      <item>for i = 1 to n

      <item> \ B[m][i] = D[m][i]

      <item>for i = (m-1) to 1

      <item> \ for j = 1 to n

      <item> \ \ \ if j == 1 //left

      <item> \ \ \ \ \ if B[i+1][j] == Min(B[i+1][j],B[i+1][j+1])

      <item> \ \ \ \ \ \ \ B[i][j] = D[i][j] + B[i+1][j]

      <item> \ \ \ \ \ \ \ C[i][j] = <math|\<downarrow\>>

      <item> \ \ \ \ \ else

      <item> \ \ \ \ \ \ \ B[i][j] = D[i][j] + B[i+1][j+1]

      <item> \ \ \ \ \ \ \ C[i][j] = <math|\<searrow\>>

      <item> \ \ \ else if j == n //right

      <item> \ \ \ \ \ if B[i+1][j] == Min(B[i+1][j],B[i+1][j-1])

      <item> \ \ \ \ \ \ \ B[i][j] = D[i][j] + B[i+1][j]

      <item> \ \ \ \ \ \ \ C[i][j] = <math|\<downarrow\>>

      <item> \ \ \ \ \ else

      <item> \ \ \ \ \ \ \ B[i][j] = D[i][j] + B[i+1][j-1]

      <item> \ \ \ \ \ \ \ C[i][j] = <math|\<swarrow\>>

      <item> \ \ \ else //middle

      <item> \ \ \ \ \ if B[i+1][j-1] == Min(B[i+1][j-1],B[i+1][j],B[i+1][j+1])

      <item> \ \ \ \ \ \ \ B[i][j] = D[i][j] + B[i+1][j-1]

      <item> \ \ \ \ \ \ \ C[i][j] = <math|\<swarrow\>>

      <item> \ \ \ \ \ else if B[i+1][j] ==
      Min(B[i+1][j-1],B[i+1][j],B[i+1][j+1])

      <item> \ \ \ \ \ \ \ B[i][j] = D[i][j] + B[i+1][j]

      <item> \ \ \ \ \ \ \ C[i][j] = <math|\<downarrow\>>

      <item> \ \ \ \ \ else

      <item> \ \ \ \ \ \ \ B[i][j] = D[i][j] + B[i+1][j+1]

      <item> \ \ \ \ \ \ \ C[i][j] = <math|\<searrow\>>

      <item>StartCol = 0

      <item>SeamCost = <math|\<infty\>>

      <item>for i = 1 to n

      <item> \ if B[1][i] \<less\> SeamCost

      <item> \ \ \ StartCol = i

      <item> \ \ \ SeamCost = B[1][i]

      <item>printf(``Total Seam Disruption: %d'',k)

      <item>printf(``The Sequence is as follows:<inactive|<hybrid|n>>'')

      <item>j = StartCol

      <item>for i = 1 to (m-1)

      <item> \ printf(``Row %d,Col %d<inactive|<hybrid|n>>'',i,j)

      <item> \ if C[i][j] == <math|<space|0.2spc>><math|\<swarrow\>>

      <item> \ \ \ j = j - 1 \ 

      <item> \ else if C[i][j] == <math|\<searrow\>>

      <item> \ \ \ j = j + 1

      <item>printf(``Row %d,Col %d<inactive|<hybrid|n>>'',m,j))
    </verbatim-code>
  </enumerate-numeric>
</body>

<\initial>
  <\collection>
    <associate|language|american>
    <associate|page-type|letter>
  </collection>
</initial>