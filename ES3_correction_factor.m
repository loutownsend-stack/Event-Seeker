%Event seeker%
%Updated 01-16-2026
%Lou Townsend


G = readtable("CH1_example.xlsx"); %load CH1 time vs intensity data 
                               % (post time scaling)
P = readtable("CH2_example.xlsx"); %load CH2 time vs intensity data
bkgdG = readtable("bkgdCh1_example.xlsx"); % load background data for CH1
bkgdP = readtable("bkgdCh2_example.xlsx"); % load background data for CH2
ArrayG = table2array(G); %convert fluo CH1/2 or bkgd xls data to array
ArrayP = table2array(P); % " "
bG = table2array(bkgdG); %
bP = table2array(bkgdP); %
%Z-score paramater, enter threshold for CI of choice: 1.96 for 95% CI
Z = str2double(input('Enter Z score threshold here:','s')); 

% If using a dim red fluorophore, or CH2 data operates on significantly 
% lower arbitrary values compared to CH1 data, program will indicate a 
% need for cf that you can choose to ignore
cf = str2double(input('Enter any correction factor here for red channel, otherwise type 0:','s'));

% Per Channel Background Subtraction
for vv = 2:width(ArrayG)  % note we iterate columnwise starting at column 2, column 1 is time 
    for bb = 1:length(ArrayG) % rowwise iteration
        ArrayG1(bb,vv) = (ArrayG(bb,vv))-(bG(bb,vv));
        ArrayP1(bb,vv) = (ArrayP(bb,vv)+cf)-(bP(bb,vv));
          near_zero_makers = find(ArrayP1(:,2:end)<1);
    end
end
 if length(near_zero_makers)>1
        display("Consider adding correction factor to CH2 data") %removes near zero
                                                       %and negative values
        cf_prompt = str2double(input('Enter 1 to restart, 0 to continue:', 's'));
    if cf_prompt == 1
         clear("ArrayP1","cf","ArrayG1","near_zero_makers","cf_prompt")
         ES3_correction_factor

    else
           
    end     
 else 
    ArrayG1(:,1) = ArrayG(:,1);
            ArrayP1(:,1) = ArrayP(:,1);


            %Events captured based on Z-score of the ratio of CH1 signal to
            %CH2 signal. 
            ratio = ArrayG1./ArrayP1;
            catcher = zeros(length(ratio), (width(ratio))); %preallocating loop data 
            catcher(:,1)= ArrayG(:,1); %time column is fixed
            
            %the following loop takes a z-score for every point in the ratio array,
            %using per sweep column average and std dev in the z-calculation. 
            %this loop fills an empty "catcher array" with a 1 only if the z-score 
            %conditions depicted in the if/else loop are satisfied (ie. ~2 std 
            %deviations above the mean = an event (1) )
            
            for vv = 2:width(ratio)  %note we iterate columnwise starting at column 2, column 1 is time 
                for bb = 1:length(ratio) %rowwise iteration
                    if (ratio(bb,vv)-mean(ratio(:,vv)))/std(ratio(:,vv))> Z %z-score   
                        catcher(bb,vv) = 1;
                       
                    else
                        
                    end
                end
            end
            display("Results by Ratio Z-score Method baseline subbed")
            events_per_sweep(1,:)= sum(catcher(:,2:width(catcher))) %sums events/sweep 
            find_events = find(catcher == 1);
            num_events = length(find_events)
            highlight_events = catcher.*ratio;
            mean_events_per_second = mean(events_per_sweep)/(catcher(length(catcher),1)/1000)
            if mean_events_per_second == 0
                display("rerun with higher correction factor")
            else
            end
            
            only_events = catcher(:,2:width(catcher));
            
            %This section organizes the data into a one X and Y column only, rather
            %than X Y Y Y Y it becomes
            % X Y
            % X Y
            % X Y   for ease of binning across all sweeps
            format_build = zeros((length(catcher)*(width(catcher)-1)),2); %sizing
            format_build(1:length(catcher),1) = catcher(:,1); %first time col
            format_build(1:length(catcher),2) = only_events(:,1); %binary events col
            
            for gg = 1: width(only_events)
                mm = gg+1;
                if mm <= width(only_events)
                    format_build((((gg)*length(only_events)+1):((mm)*length(only_events))),2)= only_events(:,mm);
                    format_build((((gg)*length(only_events)+1):((mm)*length(only_events))),1)= catcher(:,1);
                else
                   
                end
            end
            
                    
            positional_time = find(format_build(:,2) == 1); %Finds event position
            
            %Loop calculates inter event intervals, taking the time of one event minus
            %the time of the nearest previous event to generate the interval between
            
                %Note conditional loop mandates that timing at positional_time(o) must be greater than for time at (n)
                %to avoid false interval calculation
            for n = 1:length(positional_time)
                o = n+1;
                if o <= length(positional_time) 
                    if format_build(positional_time(o)) > format_build(positional_time(n))
                    inter_event_interval(n) = format_build(positional_time(o))-format_build(positional_time(n));
                    else
                    end
                else
                end
            end
            
            
            ms = inter_event_interval';  
            interevents_table = array2table(ms) ; %table of event durations in order
            
            %Binning operation and histogram generation
            binwidth = input('Enter the binwidth desired here: ', 's');
            binwidth_numeric = str2num(binwidth);
            figure
            title('Fitted Intervals Cell 2')
            number_of_bins = round((max(ms)/binwidth_numeric));
            %histogram(inter_event_interval,"BinWidth",10)
            histfit(inter_event_interval,number_of_bins,"exponential")
                
            xlabel('Interval Duration (ms)')
            ylabel('Number of Inter Event Intervals')
            
            %% For individual sweep Raster-like plotting of events
            
            raster_table = zeros(length(catcher),width(catcher));
            raster_table(:,1) = catcher(:,1);
            for t = 2:width(catcher)
                    raster_table(:,t) = catcher(:,t)*(t-1); %multiplies catcher by sweep #
            end
            
            %plotting then makes 1's for events detected in sweep one, 2's for sweep 2, 3 for sweep 3, and so on for easy
            %visualization    
 end

