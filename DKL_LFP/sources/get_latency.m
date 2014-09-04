function latency_data=get_latency(ref_package, tar_package, params)
%function latency_data=get_latency(ref_package, tar_package, params, ud)
%Compute the mean and std of the latencies of signal segments contained in intervals
%defined in ref_package and tar_package.
%Author: Murat Okatan. 04/10/03.

%version 7. Interval numbers are computed for those onsets that are within intervals too.
%version 6. Augmented params by 1 element.
%version 5. Return interval packages of those intervals that were used in
%   computing latencies.
%version 4. Return the interval numbers of those intervals that were used in
%   computing latencies.
%version 3. Return the tstamps of the onsets that were used to compute the latencies.
%version 2. Return a flag that indicates the occurrence of onset collisions in
%   reference and/or the target signal.
%version 1. Compute the mean and std of latencies in target signal segments relative to
%   reference signal segments.

%Default
latency_data=[];


ref_onset_indeces=get_onset(ref_package, params);
tar_onset_indeces=get_onset(tar_package, params);

ref_onset_times=ref_package.saved_signals.t(ref_onset_indeces);
tar_onset_times=tar_package.saved_signals.t(tar_onset_indeces);

[tarM, refM]=meshgrid(tar_onset_times, ref_onset_times);
latM=tarM-refM;
[i, j]=find(abs(latM)<=params(5));

if isempty(i),
    return;
end

collision_flag=0;
for k=1:length(i),
    indxi=find(i==i(k));
    indxj=find(j==j(k));
	if length(indxi)>1 | length(indxj)>1,
        collision_flag=(length(indxj)>1)+2*(length(indxi)>1);
	end
end

k=find(abs(latM(:))<=params(5));

%Find the interval numbers
for m=1:length(k),
    %Index of the target onset time in *_onset_times vector
    ref_indx=find(ref_onset_times==refM(k(m)));
    tar_indx=find(tar_onset_times==tarM(k(m)));
    
    %Index of the * onset time in signals.t vector
    ref_indx=ref_onset_indeces(ref_indx);
    tar_indx=tar_onset_indeces(tar_indx);
    
    enclosed=ref_package.saved_signals.start_indx<=ref_indx & ...
             ref_package.saved_signals.end_indx  >=ref_indx;
    enclosed=~all(enclosed==0);
    if enclosed,
        %The closest interval start index to the left
        ref_int_nums(m)=max(find(ref_package.saved_signals.start_indx<=ref_indx));
    else
        %The closest interval start index to the right
        ref_int_nums(m)=min(find(ref_package.saved_signals.start_indx>=ref_indx));
    end
    
    enclosed=tar_package.saved_signals.start_indx<=tar_indx & ...
             tar_package.saved_signals.end_indx  >=tar_indx;
    enclosed=~all(enclosed==0);
    if enclosed,
        %The closest interval start index to the left
        tar_int_nums(m)=max(find(tar_package.saved_signals.start_indx<=tar_indx));
    else
        %The closest interval start index to the right
        tar_int_nums(m)=min(find(tar_package.saved_signals.start_indx>=tar_indx));
    end
end

%Form the interval packages
ref_int_pack.start_indx=ref_package.saved_signals.start_indx(ref_int_nums);
ref_int_pack.end_indx=ref_package.saved_signals.end_indx(ref_int_nums);
ref_int_pack.start_times=ref_package.saved_signals.t(ref_int_pack.start_indx);
ref_int_pack.end_times=ref_package.saved_signals.t(ref_int_pack.end_indx);
ref_int_pack.categories=zeros(1, length(ref_int_nums));

tar_int_pack.start_indx=tar_package.saved_signals.start_indx(tar_int_nums);
tar_int_pack.end_indx=tar_package.saved_signals.end_indx(tar_int_nums);
tar_int_pack.start_times=tar_package.saved_signals.t(tar_int_pack.start_indx);
tar_int_pack.end_times=tar_package.saved_signals.t(tar_int_pack.end_indx);
tar_int_pack.categories=zeros(1, length(tar_int_nums));



%Form the latency_data struct
latency_data.mean=mean(latM(k));
latency_data.std=std(latM(k));
latency_data.num=length(k);
latency_data.flag=collision_flag;
latency_data.ref_onset_times=refM(k);
latency_data.tar_onset_times=tarM(k);
latency_data.ref_int_nums=ref_int_nums;
latency_data.tar_int_nums=tar_int_nums;
latency_data.ref_int_pack=ref_int_pack;
latency_data.tar_int_pack=tar_int_pack;
