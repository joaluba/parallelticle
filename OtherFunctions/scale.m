function new=scale(old,NewMin,NewMax)

OldRange = (max(old) - min(old));  
NewRange = (NewMax - NewMin); 
new = (((old - min(old)) .* NewRange) ./ OldRange) + NewMin;

end