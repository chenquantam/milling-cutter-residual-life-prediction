%用于???机森林的代?
function  [tree,discrete_dim] = train_C4_5(S, inc_node, Nu, discrete_dim)  
      
    % Classify using Quinlan's C4.5 algorithm  
    % Inputs:  
    %   training_patterns   - Train patterns ???本  每一列代表一??本 每一行代表一?特征
    %   training_targets    - Train targets  1×???本?? 每????本??的判?值
    %   test_patterns       - Test  patterns ???本，每一列代表一??本  
    %   inc_node            - Percentage of incorrectly assigned samples at a node  一???上未正确分配的?本的百分比
    %   inc_node?防止??合，表示?本?小于一定?值?束??，可?置?5-10
    %   注意inc_node?置太大的???致分?准确率下降，太小的?可能??致??合  
    %  Nu is to determine whether the variable is discrete or continuous (the value is always set to 10)  
    %  Nu用于确定?量是离散?是??（?值始??置?10）
    %  ?里用10作?一??值，如果某?特征的?重复的特征值的?目比???值?小，就????特征是离散的
    % Outputs  
    %   test_targets        - Predicted targets 1×???本?? 得到每????本??的判?值
    %   也就是?出所有???本最?的判?情?
      
    %NOTE: In this implementation it is assumed that a pattern vector with fewer than 10 unique values (the parameter Nu)  
    %is discrete, and will be treated as such. Other vectors will be treated as continuous  
    % 在???中，假?具有少于10??重复值的特征向量（??Nu）是离散的。 其他向量?被????的
    train_patterns = S(:,1:end-1)';      
    train_targets = S(:,end)';   
    [Ni, M]     = size(train_patterns); %M是???本?，Ni是???本??，即是特征?目
    inc_node    = inc_node*M/100;  % 5*???本?目/100
    if isempty(discrete_dim)  
        %Find which of the input patterns are discrete, and discretisize the corresponding dimension on the test patterns  
        %查找哪些?入模式(特征)是离散的，并离散??模式上的相??
        discrete_dim = zeros(1,Ni); %用于??每一?特征是否是离散特征，初始化都??0，代表都是??特征，
        %如果后面更改，?意味?是离散特征，??值?更改???离散特征的?重复特征值的?目 
        for i = 1:Ni  %遍?每?特征
            Ub = unique(train_patterns(i,:));  %取每?特征的不重复的特征值构成的向量 
            Nb = length(Ub);    %得到?重复的特征值的?目
            if (Nb <= Nu)  %如果??特征的?重复的特征值的?目比???值?小，就????特征是离散的  
                %This is a discrete pattern  
                discrete_dim(i) = Nb; %得到???本中，??特征的?重复的特征值的?目 存放在discrete_dim(i)中，i表示第i?特征
    %             dist            = abs(ones(Nb ,1)*test_patterns(i,:) - Ub'*ones(1, size(test_patterns,2))); 
    %             %前面是把???本中，??特征的那一行复制成Nb行，Nb是???本的??特征中，?重复的特征值的?目
    %             %后面是把?几??重复的特征值构成的向量复制成???本??列
    %             %求???矩?相?位置差的??值
    %             [m, in]         = min(dist);  %找到每一列??差的最小值，构成m(1×?本?目)   并找到每一列??差最小值所在行的位置，构成in(1×?本?目)
    %             %其?，??in的中每?值就是代表了每????本的特征值等于?重复的特征值中的哪一?或者更接近于哪一?
    %             %如=3，就是指??特征值等于?重复的特征值向量中的第3?或者更接近于?重复的特征值向量中的第3?
    %             test_patterns(i,:)  = Ub(in);  %得到??离散特征
            end  
        end  
    end
        
      
    %Build the tree recursively  ??地构造?
%     disp('Building tree')  
    flag = [];
    tree  = make_tree(train_patterns, train_targets, inc_node, discrete_dim, max(discrete_dim), 0, flag);  
    
    function tree = make_tree(patterns, targets, inc_node, discrete_dim, maxNbin, base, flag)  
    %Build a tree recursively   ??地构造?
      
    [N_all, L]                     = size(patterns);  %%L??前的?本??，Ni?特征?目
    if isempty(flag)
        N_choose = randi([1,N_all],1,0.5*sqrt(N_all));%?所有特征中?机??m?
        Ni_choose = length(N_choose);
        flag.N_choose = N_choose;
        flag.Ni_choose = Ni_choose;
    else
        N_choose = flag.N_choose;
        Ni_choose = flag.Ni_choose;
    end
    
    Uc                          = unique(targets);  %???本??的判???   ?重复的取得?些??  也就是得到判???的??
    tree.dim                    = 0;  %初始化?的分裂特征?第0?
    %tree.child(1:maxNbin)  = zeros(1,maxNbin);  
    tree.split_loc              = inf;  %初始化分裂位置是inf
      
    if isempty(patterns) 
        return  
    end  
      
    %When to stop: If the dimension is one or the number of examples is small 
    % inc_node?防止??合，表示?本?小于一定?值?束??，可?置?5-10
    if ((inc_node > L) | (L == 1) | (length(Uc) == 1)) %如果剩余???本太小(小于inc_node)，或只剩一?，或只剩一???，退出  
        H                   = hist(targets, length(Uc));  %???本的??，分??于每???的?目    H(1×???目)
        [m, largest]    = max(H); %得到包含?本?最多的那???的索引，??largest 包含多少??本，??m
        tree.Nf         = [];  
        tree.split_loc  = [];  
        tree.child      = Uc(largest);%姑且直接返回其中包含?本?最多一?作?其?? 
        return  
    end  
      
    %Compute the node's I  
    for i = 1:length(Uc) %遍?判???的?目 
        Pnode(i) = length(find(targets == Uc(i))) / L;  %得到?前所有?本中 ??=第i??? 的?本的?目  占?本??的比例  存放在Pnode(i)中
    end  
%   ?算?前的信息熵（分?期望信息）
% 	例如，?据集D包含14????本，9??于??“Yes”，5??于??“No”，Inode = -9/14 * log2(9/14) - 5/14 * log2(5/14) = 0.940
    Inode = -sum(Pnode.*log(Pnode)/log(2));  
      
    %For each dimension, compute the gain ratio impurity ％?于每?，?算??的增益比  ?特征集中每?特征分??算信息熵
    %This is done separately for discrete and continuous patterns     ％?于离散和??特征，分??算
    delta_Ib    = zeros(1, Ni_choose);  %Ni是特征??  用于??每?特征的信息增益率
    split_loc   = ones(1, Ni_choose)*inf;  %初始化每?特征的分裂值是inf
      
    for i_idx = 1:Ni_choose%遍?每?特征  
        i = N_choose(i_idx);
        data    = patterns(i,:);  %得到?前所有?本的??特征的特征值
        Ud      = unique(data);   %得到?重复的特征值构成向量Ud
        Nbins   = length(Ud);     %得到?重复的特征值的?目
        if (discrete_dim(i)) %如果??特征是离散特征 
            %This is a discrete pattern  
            P   = zeros(length(Uc), Nbins);  %Uc是判???的??   判?????×?重复的特征值的?目
            for j = 1:length(Uc) %遍?每???  
                for k = 1:Nbins %遍?每?特征值  
                    indices     = find((targets == Uc(j)) & (patterns(i,:) == Ud(k)));  
                    % &适用于矩??的???算 &&不适用，只能用于??元素 &的意思也是与
                    %找到 （?本??==第j???  并且 ?前所有?本的??特征==第k?特征值） 的?本??
                    P(j,k)  = length(indices);  %??P(j,k)
                end  
            end  
            Pk          = sum(P);  %取P的每一列的和，也就是得到?前所有?本中，??特征的特征值==??特征值的?本?目   Pk(1×特征值?目)表示??特征的特征值等于每?特征值的?本?目
            P1          = repmat(Pk, length(Uc), 1);  %把Pk复制成 判????? 行
            P1          = P1 + eps*(P1==0);  %?主要在保?P1作被除??不等于0
            P           = P./P1;  %得到?前所有?本中，??特征的值等于每?特征值且??等于每???的?本，占?前??特征值中的?本的比例
            Pk          = Pk/sum(Pk);  %得到?前所有?本中，??特征的值等于每?特征值的?本，占?前?本??的比例
            info        = sum(-P.*log(eps+P)/log(2));  %?特征集中每?特征分??算信息熵  info(1×特征值?目)
            delta_Ib(i_idx) = (Inode-sum(Pk.*info))/(-sum(Pk.*log(eps+Pk)/log(2))); %?算得到?前特征的信息增益率
            %?算信息增益率(GainRatio)，公式?Gain(A)/I(A),
            %其中Gain(A)=Inode-sum(Pk.*info)就是?性A的信息增益
            %其中I(A)=-sum(Pk.*log(eps+Pk)/log(2))??性A的所包含的信息
        else   %?于??特征(主要要找到合适的分裂值，使?据离散化)
            %This is a continuous pattern  
            P   = zeros(length(Uc), 2);  %   P(判????目×2)  列1代表前..??本中的??分布情?   列2代表除前..??本之外的??分布情?  ??..就是各?分裂位置
      
            %Sort the patterns  
            [sorted_data, indices] = sort(data);  %data里存放的是?前所有???本的??特征的特征值   ?小到大排序  sorted_data是排序好的?据 indices是索引
            sorted_targets = targets(indices);  %?然，判???也要???本?序?整而?整
      
            %Calculate the information for each possible split  ?算分裂信息度量
              I = zeros(1,Nbins);
              delta_Ib_inter    = zeros(1, Nbins);
              for j = 1:Nbins-1
                  P(:, 1) = hist(sorted_targets(find(sorted_data <= Ud(j))) , Uc);  %??<=?前特征值的?本的??的分布情?
                  P(:, 2) = hist(sorted_targets(find(sorted_data > Ud(j))) , Uc);  %??>?前特征值的?本的??的分布情?
                  Ps      = sum(P)/L;  %sum(P)是得到分裂位置前面和后面各有?本?占?前?本??的比例
                  P       = P/L;  %占?本??的比例
                  Pk      = sum(P);   %%sum(P)是得到分裂位置前面和后面各有多少??本 比例 
                  P1      = repmat(Pk, length(Uc), 1);  %把Pk复制成 判????? 行
                  P1      = P1 + eps*(P1==0);  
                  info    = sum(-P./P1.*log(eps+P./P1)/log(2));  %?算信息熵（分?期望信息）
                  I(j)    = Inode - sum(info.*Ps);  %Inode-sum(info.*Ps)就是以第j??本分裂的的信息增益   
                  delta_Ib_inter(j) =  I(j)/(-sum(Ps.*log(eps+Ps)/log(2))); %?算得到?前特征值的信息增益率
              end

            [~, s] = max(I);  %找到信息增益最大的划分方法  delta_Ib(i)中存放的是?于?前第i?特征而言，最大的信息增益作???特征的信息增益  s存放??划分方法
            delta_Ib(i_idx) = delta_Ib_inter(s);  %得到??分?特征值??的信息增益率
            split_loc(i_idx) = Ud(s);  %??特征i的划分位置就是能使信息增益最大的划分值
        end  
    end  
      
    %Find the dimension minimizing delta_Ib    %找到?前要作?分裂特征的特征
    [m, dim]    = max(delta_Ib);  %找到所有特征中最大的信息增益??的特征，??dim
    dims        = 1:Ni_choose;  %Ni特征?目
    dim_all = 1:N_all;
    dim_to_all = N_choose(dim);
    tree.dim = dim_to_all;  %???的分裂特征
      
    %Split along the 'dim' dimension  
    Nf      = unique(patterns(dim_to_all,:));  %得到??的??作?分裂特征的特征的那一行  也就是得到?前所有?本的??特征的特征值
    Nbins   = length(Nf);  %得到??特征的?重复的特征值的?目
    tree.Nf = Nf;  %???的分?特征向量 ?前所有?本的??特征的特征值
    tree.split_loc      = split_loc(dim);  %把??特征的划分位置???的分裂位置  可是如果??的是一?离散特征，split_loc(dim)是初始值inf啊？？？
      
    %If only one value remains for this pattern, one cannot split it.  
    if (Nbins == 1)  %?重复的特征值的?目==1，即??特征只有?一?特征值，就不能?行分裂
        H               = hist(targets, length(Uc));  %???前所有?本的??，分??于每???的?目    H(1×???目)
        [m, largest]    = max(H);  %得到包含?本?最多的那???的索引，??largest 包含多少??本，??m
        tree.Nf         = [];  %因?不以??特征?行分裂，所以Nf和split_loc都?空
        tree.split_loc  = [];  
        tree.child      = Uc(largest);  %姑且???特征的??就??包含?本?最多的那???
        return  
    end  
      
    if (discrete_dim(dim_to_all))  %如果?前??的??作?分裂特征的特征是?离散特征 
        %Discrete pattern  
        for i = 1:Nbins   %遍???特征下?重复的特征值的?目
            indices         = find(patterns(dim_to_all, :) == Nf(i));  %找到?前所有?本的??特征的特征值?Nf(i)的索引?
            tree.child(i)   = make_tree(patterns(dim_all, indices), targets(indices), inc_node, discrete_dim(dim_all), maxNbin, base, flag);%??
            %因??是?离散特征，所以分叉成Nbins?，分???每?特征值里的?本，?行再分叉
        end  
    else  
        %Continuous pattern  %如果?前??的??作?分裂特征的特征是???特征 
        indices1            = find(patterns(dim_to_all,:) <= split_loc(dim));  %找到特征值<=分裂值的?本的索引?
        indices2            = find(patterns(dim_to_all,:) > split_loc(dim));   %找到特征值>分裂值的?本的索引?
        if ~(isempty(indices1) | isempty(indices2))  %如果<=分裂值 >分裂值的?本?目都不等于0  
            tree.child(1)   = make_tree(patterns(dim_all, indices1), targets(indices1), inc_node, discrete_dim(dim_all), maxNbin, base+1, flag);%?? 
            %?<=分裂值的?本?行再分叉
            tree.child(2)   = make_tree(patterns(dim_all, indices2), targets(indices2), inc_node, discrete_dim(dim_all), maxNbin, base+1, flag);%?? 
            %?>分裂值的?本?行再分叉
        else  
            H               = hist(targets, length(Uc));  %???前所有?本的??，分??于每???的?目    H(1×???目)
            [m, largest]    = max(H);   %得到包含?本?最多的那???的索引，??largest 包含多少??本，??m
            tree.child      = Uc(largest);  %姑且???特征的??就??包含?本?最多的那???  
            tree.dim                = 0;  %?的分裂特征??0
        end  
    end  
