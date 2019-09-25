function [chosenprob, chosenval, hits, notchosenprob, notchosenval] = parse_choices(S)

chosenprob = nan(length(S.pd{1}.hits), 1);
chosenval = chosenprob;
notchosenprob = chosenprob;
notchosenval = chosenprob;

r = find(S.pd{1}.went_right==1);
chosenprob(r) = S.pd{1}.right_prob(r);
chosenval(r) = S.pd{1}.this_right_volume(r);
notchosenprob(r) = S.pd{1}.left_prob(r);
notchosenval(r) = S.pd{1}.this_left_volume(r);

l = find(S.pd{1}.went_right==0);
chosenprob(l) = S.pd{1}.left_prob(l);
chosenval(l) = S.pd{1}.this_left_volume(l);
notchosenprob(l) = S.pd{1}.right_prob(l);
notchosenval(l) = S.pd{1}.this_right_volume(l);


hits = nan(length(chosenprob), 1);
h = find(S.pd{1}.went_right==1 & S.pd{1}.right_hit==1 | ...
    S.pd{1}.went_left==1 & S.pd{1}.left_hit==1);
hits(h) = 1;
h = find(S.pd{1}.went_right==1 & S.pd{1}.right_hit==0 | ...
    S.pd{1}.went_left==1 & S.pd{1}.left_hit==0);
hits(h) = 0;