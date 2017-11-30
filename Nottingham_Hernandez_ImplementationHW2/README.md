# Quad Tree Data Structure in Processing by Bailey Nottingham and Mario Hernandez.

1. Read File Button
   * This program will read in an input file as per spec, and will insert the line segments into the quad tree data structure. When a valid file is read, the quad tree will be initialized. When a
   file is read and the quad tree initializes, if the user clicks on read file, a pop up will
   prompt them to terminate and restart the program if they want to enter a new file.

2. Insert Mode / Button
   * The user will have the ability to insert new points into the quad tree data structure. The Quad Tree will then split leaf nodes accordingly. The rule is if there is more than 3 line segments in a node, then the node will split into four equal size rectangles. There is also a limit to the height of the quad tree so there will be an error message printed out to the console, if you try to insert a point into a node that has already reached the maximum height.

3. Report Mode / Button
   * The user will have the ability to 'report' what data structures lay in the region, query disk, specified by the user. When report mode is turned on, the first click will determine the top left point of the query rectangle, and the second click will represent the bottom right point of the query rectangle. If the second point is to the left or above the first point, then you will have the opportunity to fix the second click.

4. Animation Mode / Button
   * When the animation button is clicked, the insertions of points, and the querying of the line segments will be animated as per the spec.

5. Party Mode / Button
   * When the Party Button is clicked, the user's ability to query, and insert will turn off. In party mode, whenever the user clicks on the white canvas, fire works will appear.

6. Assumptions
   * In order to insert, a valid file must be read. The file could have no line segments, but the minimum requirements for the file is to the height of the quad tree specified.
   * In order to use report, a valid file must be read. The file could have no line segments, but the minimum requirements for the file is to the height of the quad tree specified.
   * Party mode cannot be used unless there is a valid quad tree initialized.
   * If a user wants to enter a new file after one has already been read. The user must
   terminate and restart the program to do so.
