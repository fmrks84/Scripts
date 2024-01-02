/*select * from dbamv.regra 
where regra.cd_regra = 313

update dbamv.itregra set itregra.cd_tab_fat = 317
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (138,346);   ----- já consta 

update dbamv.itregra set itregra.cd_tab_fat = 461
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (309);  -- já consta 

update dbamv.itregra set itregra.cd_tab_fat = 301
where itregra.cd_tab_fat = 301
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (145,146,357,111,359); ----- já consta 

update dbamv.itregra set itregra.cd_tab_fat = 458
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (319,322,324,325); --- já consta 

update dbamv.itregra set itregra.cd_tab_fat = 319
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (183,184,358);  ---- já consta 
*/

/*select  * from dbamv.itregra 
where itregra.cd_regra in (313,326,329,330,331,332,309,306,307,308,354,319,322,
324,325,336,337,145,146,357,236,111,359,183,184,358,84,295,281,243,282,283,284,
89,311,92,91,253,297,298,96,98,280,286,287,264,106,210,279,227,338,339,301,302,
303,304,305,335,113,117,197,293,290,291,292,342,343,347,299,300,151,138,346)
and itregra.cd_gru_pro = 0
order by 2 
--for update */
  
update dbamv.itregra set itregra.cd_tab_fat = 501
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra = 313;

update dbamv.itregra set itregra.cd_tab_fat = 499
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra = 326;

update dbamv.itregra set itregra.cd_tab_fat = 500
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (329,330,331,332);

update dbamv.itregra set itregra.cd_tab_fat = 469
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (306,307,308,354);

update dbamv.itregra set itregra.cd_tab_fat = 470
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (336,337);

update dbamv.itregra set itregra.cd_tab_fat = 471
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (84);

update dbamv.itregra set itregra.cd_tab_fat = 472
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (295);

update dbamv.itregra set itregra.cd_tab_fat = 474
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (281);

update dbamv.itregra set itregra.cd_tab_fat = 475
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (243,282,283,284);

update dbamv.itregra set itregra.cd_tab_fat = 477
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (89);

update dbamv.itregra set itregra.cd_tab_fat = 478
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (311);

update dbamv.itregra set itregra.cd_tab_fat = 479
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (92);

update dbamv.itregra set itregra.cd_tab_fat = 476
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (91,253);

update dbamv.itregra set itregra.cd_tab_fat = 480
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (297);

update dbamv.itregra set itregra.cd_tab_fat = 493
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (298);

update dbamv.itregra set itregra.cd_tab_fat = 481
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (96);

update dbamv.itregra set itregra.cd_tab_fat = 482
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (98);

update dbamv.itregra set itregra.cd_tab_fat = 483
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (280);

update dbamv.itregra set itregra.cd_tab_fat = 484
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (286,287);

update dbamv.itregra set itregra.cd_tab_fat = 485
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (264);

update dbamv.itregra set itregra.cd_tab_fat = 486
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (106,210);

update dbamv.itregra set itregra.cd_tab_fat = 487
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (279);

update dbamv.itregra set itregra.cd_tab_fat = 488
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (227);

update dbamv.itregra set itregra.cd_tab_fat = 489
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (338,339);

update dbamv.itregra set itregra.cd_tab_fat = 490
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (301,302,303,304,305,335);

update dbamv.itregra set itregra.cd_tab_fat = 491
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (113);

update dbamv.itregra set itregra.cd_tab_fat = 492
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (117,197);

update dbamv.itregra set itregra.cd_tab_fat = 494
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (293);

update dbamv.itregra set itregra.cd_tab_fat = 495
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (290,291,292,342,343,347);

update dbamv.itregra set itregra.cd_tab_fat = 496
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (299);

update dbamv.itregra set itregra.cd_tab_fat = 497
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (300);

update dbamv.itregra set itregra.cd_tab_fat = 498
where itregra.cd_tab_fat = 3
and itregra.cd_gru_pro = 0
and itregra.cd_regra in (151);

commit
