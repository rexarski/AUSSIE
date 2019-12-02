## Comments

### RMIT

RMIT is the only uni so far that requires a document analysis (kinda). Thanks to the formality of a table (in fact, multiple tables), it is not painful to extract all of them.

### Deakin

On the contrary, I first thought Deakin's data is only contained in its corresponding pdf version handbook. That was really a PITA (guess what does this mean?) because although a toc is two-column, the data scraped is not. So matching left data from the left column and its leftovers onto the next line is even impossible. It feels really confusing even now I'm describing this to you and to myself. Just forget about it, I eventually figured out where to scrape the data.

### Griffith

the lazy loading mechanics (if i'm correct) is really annoying in this website
"https://www.griffith.edu.au/study/courses"
In detail, if we dive into the developer console of web browser, the secret is unveiled: each time we scroll to the end of this page, an additional 500 resultst will be rendered after a few seconds. So the best practice here is to directly get the response as json, dump them locally and deal with them later.

a response url looks like
https://www.griffith.edu.au/_designs/search/degree-search?num_ranks=500&start_rank=2001&collection=courses-api
and we can modify the parameters to catch them all at the same time!
https://www.griffith.edu.au/_designs/search/degree-search?num_ranks=3500&start_rank=1&collection=courses-api

The next step is to deal with json file ;)

### USC

Search results only contain top 50 out of all results. :( Why? It's impossible to extract all data if the data itself is kept secret.

## Reference

- [strsplit with vertical bar](https://stackoverflow.com/questions/23193219/strsplit-with-vertical-bar-pipe)
- [Remove a subset of records from a dataframe in r](https://stackoverflow.com/questions/38759429/remove-a-subset-of-records-from-a-dataframe-in-r)
- [Merge extra contents to the left when splitting one column to two with multiple delimiters](https://stackoverflow.com/questions/33109799/merge-extra-contents-to-the-left-when-splitting-one-column-to-two-with-multiple)
- [How to split a string from right-to-left, like Python's rsplit()?](https://stackoverflow.com/questions/20454768/how-to-split-a-string-from-right-to-left-like-pythons-rsplit)
- [Why is message() a better choice than print() in R for writing a package?](https://stackoverflow.com/questions/36699272/why-is-message-a-better-choice-than-print-in-r-for-writing-a-package/36700294)
- [How to extract date from a multiline string or File in R](https://stackoverflow.com/questions/58156097/how-to-extract-date-from-a-multiline-string-or-file-in-r)

## Todo
  
- [x] [Monash](http://www.monash.edu/pubs/2019handbooks/units/index-bycode.html)
- [x] [Adelaide](https://www.adelaide.edu.au/course-outlines/)
- [x] [UWA](https://handbooks.uwa.edu.au/search?type=units)
- [x] [RMIT](https://www.rmit.edu.au/content/dam/rmit/documents/staff-site/servicesandtools/finance/2020-HE-course-list.pdf)
- [x] [Deakin](https://www.deakin.edu.au/courses-search/unit-search.php?hidCurrentYear=2020&hidYear=2020&hidType=max&txtUnit=&txtTitle=&txtKeyword=&selLevel=Select&selSemester=Select&selMode=Select&selLocation=B&chkSortby=unit_cd&btnSubmit=)

- [x] [Victoria](https://www.vu.edu.au/courses/search?iam=resident&query=&type=Unit)
- [x] [Bond University](https://bond.edu.au/current-students/study-information/subjects?type=1&area=All)
- [x] [Curtin](http://handbook.curtin.edu.au/unitSearch.html)
- [x] [Griffith](https://www.griffith.edu.au/study/courses)
- [x] [Murdoch](http://handbook.murdoch.edu.au/units/?year=2020&sort=UnitCd)
- [x] [Southern Cross Univeristy](https://www.scu.edu.au/study-at-scu/unit-search/?year=2020)
- [x] [Newcastle](https://www.newcastle.edu.au/course)
- [x] [Wollongong](https://solss.uow.edu.au/sid/cal.USER_CALENDAR_SELECT_SCREEN?p_cal_types=UP&p_breadcrumb_type=1&p_menu_type=1&p_cs=8794042783047766832)
- [x] [Sunshine Coast](https://www.usc.edu.au/learn/courses-and-programs/courses/search-for-usc-courses?courseCode=&keyword=&teachingPeriodOfOffer=Semester+1&school=&offeredLocations=&submit=Search&searchType=coursesonly#coursesonly)

***
- [x] UTS -- Vicky
- [x] UC -- Vicky
- [x] QUT -- Vicky
- [x] La Trobe -- Vicky
- [x] Macquarie -- Vicky
- [x] [Tasmania](https://www.utas.edu.au/courses/unit-search?query=&collection=handbook-meta&clive=handbook-units&sort=&meta_B_and=&meta_A_and=&meta_F_phrase_and=&meta_M_phrase_and=&meta_J_phrase_and=&meta_unitYear=2020&meta_D_phrase_and=&meta_U_phrase_and=&meta_N_phrase_and=&meta_E_phrase_and=&meta_V_phrase_and=) -- Vicky