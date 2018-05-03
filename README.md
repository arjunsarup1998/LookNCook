# LookNCook
Summary: This app allows you to input in the ingredients you have and generates recipes matching those ingredients. The recipes that require the least amount of additional ingredients are displayed first.

Description: In LookNCook, you can perform a simple search for the ingredients you require. We make calls to the Nutritionix API platform whenever you enter a letter, and display the matching ingredients returned by that API on the tableViewController. The SwiftyJSON cocoa pod was incorporated in our app to make the JSON parsing simpler. Once you select an ingredient, it is displayed as a removable tag at the top of the keyboard. This allows you to edit the list of ingredients you want to search for.

Now, when we finally click on search, the app displays a list of matching ingredients, ordered by how many ingredients are missing. Basically, it displays the recipe you have the most ingredients to make first. To get the matching ingredients, we made a call to the Yummly API. 

Ok, so once you click on a recipe you like, it displays what your food will look like along with ingredients you require to make it. The back button allows you to go back to the ingredients searcher, and the download button will allow you to save your recipe for offline storage. I am still working on the latter functionality, and was going to use core data to implement it. 

So, yeah that’s it. Happy looking!

Screenshots:

![ScreenShot](https://i.imgur.com/Mdl7nsa.png)
![ScreenShot](https://i.imgur.com/TRKulX4.png)
![ScreenShot](https://i.imgur.com/7voUoaG.png)
