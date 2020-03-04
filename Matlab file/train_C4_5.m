%�Τ_???��˪L���N?
function  [tree,discrete_dim] = train_C4_5(S, inc_node, Nu, discrete_dim)  
      
    % Classify using Quinlan's C4.5 algorithm  
    % Inputs:  
    %   training_patterns   - Train patterns ???��  �C�@�C�N��@??�� �C�@��N��@?�S��
    %   training_targets    - Train targets  1��???��?? �C????��??���P?��
    %   test_patterns       - Test  patterns ???���A�C�@�C�N��@??��  
    %   inc_node            - Percentage of incorrectly assigned samples at a node  �@???�W�����̤��t��?�����ʤ���
    %   inc_node?����??�X�A���?��?�p�_�@�w?��?��??�A�i?�m?5-10
    %   �`�Ninc_node?�m�Ӥj��???�P��?���̲v�U���A�Ӥp��?�i��??�P??�X  
    %  Nu is to determine whether the variable is discrete or continuous (the value is always set to 10)  
    %  Nu�Τ_�̩w?�q�O�ô�?�O??�]?�ȩl??�m?10�^
    %  ?����10�@?�@??�ȡA�p�G�Y?�S����?���`���S���Ȫ�?�ؤ�???��?�p�A�N????�S���O�ô���
    % Outputs  
    %   test_targets        - Predicted targets 1��???��?? �o��C????��??���P?��
    %   �]�N�O?�X�Ҧ�???����?���P?��?
      
    %NOTE: In this implementation it is assumed that a pattern vector with fewer than 10 unique values (the parameter Nu)  
    %is discrete, and will be treated as such. Other vectors will be treated as continuous  
    % �b???���A��?�㦳�֤_10??���`�Ȫ��S���V�q�]??Nu�^�O�ô����C ��L�V�q?�Q????��
    train_patterns = S(:,1:end-1)';      
    train_targets = S(:,end)';   
    [Ni, M]     = size(train_patterns); %M�O???��?�ANi�O???��??�A�Y�O�S��?��
    inc_node    = inc_node*M/100;  % 5*???��?��/100
    if isempty(discrete_dim)  
        %Find which of the input patterns are discrete, and discretisize the corresponding dimension on the test patterns  
        %�d�����?�J�Ҧ�(�S��)�O�ô����A�}�ô�??�Ҧ��W����??
        discrete_dim = zeros(1,Ni); %�Τ_??�C�@?�S���O�_�O�ô��S���A��l�Ƴ�??0�A�N���O??�S���A
        %�p�G�Z�����A?�N��?�O�ô��S���A??��?���???�ô��S����?���`�S���Ȫ�?�� 
        for i = 1:Ni  %�M?�C?�S��
            Ub = unique(train_patterns(i,:));  %���C?�S���������`���S�����ۦ����V�q 
            Nb = length(Ub);    %�o��?���`���S���Ȫ�?��
            if (Nb <= Nu)  %�p�G??�S����?���`���S���Ȫ�?�ؤ�???��?�p�A�N????�S���O�ô���  
                %This is a discrete pattern  
                discrete_dim(i) = Nb; %�o��???�����A??�S����?���`���S���Ȫ�?�� �s��bdiscrete_dim(i)���Ai��ܲ�i?�S��
    %             dist            = abs(ones(Nb ,1)*test_patterns(i,:) - Ub'*ones(1, size(test_patterns,2))); 
    %             %�e���O��???�����A??�S�������@���`�Nb��ANb�O???����??�S�����A?���`���S���Ȫ�?��
    %             %�Z���O��?�L??���`���S�����ۦ����V�q�`�???��??�C
    %             %�D???�x?��?��m�t��??��
    %             [m, in]         = min(dist);  %���C�@�C??�t���̤p�ȡA�ۦ�m(1��?��?��)   �}���C�@�C??�t�̤p�ȩҦb�檺��m�A�ۦ�in(1��?��?��)
    %             %��?�A??in�����C?�ȴN�O�N��F�C????�����S���ȵ��_?���`���S���Ȥ������@?�Ϊ̧󱵪�_���@?
    %             %�p=3�A�N�O��??�S���ȵ��_?���`���S���ȦV�q������3?�Ϊ̧󱵪�_?���`���S���ȦV�q������3?
    %             test_patterns(i,:)  = Ub(in);  %�o��??�ô��S��
            end  
        end  
    end
        
      
    %Build the tree recursively  ??�a�۳y?
%     disp('Building tree')  
    flag = [];
    tree  = make_tree(train_patterns, train_targets, inc_node, discrete_dim, max(discrete_dim), 0, flag);  
    
    function tree = make_tree(patterns, targets, inc_node, discrete_dim, maxNbin, base, flag)  
    %Build a tree recursively   ??�a�۳y?
      
    [N_all, L]                     = size(patterns);  %%L??�e��?��??�ANi?�S��?��
    if isempty(flag)
        N_choose = randi([1,N_all],1,0.5*sqrt(N_all));%?�Ҧ��S����?��??m?
        Ni_choose = length(N_choose);
        flag.N_choose = N_choose;
        flag.Ni_choose = Ni_choose;
    else
        N_choose = flag.N_choose;
        Ni_choose = flag.Ni_choose;
    end
    
    Uc                          = unique(targets);  %???��??���P???   ?���`�����o?��??  �]�N�O�o��P???��??
    tree.dim                    = 0;  %��l��?�������S��?��0?
    %tree.child(1:maxNbin)  = zeros(1,maxNbin);  
    tree.split_loc              = inf;  %��l�Ƥ�����m�Oinf
      
    if isempty(patterns) 
        return  
    end  
      
    %When to stop: If the dimension is one or the number of examples is small 
    % inc_node?����??�X�A���?��?�p�_�@�w?��?��??�A�i?�m?5-10
    if ((inc_node > L) | (L == 1) | (length(Uc) == 1)) %�p�G�ѧE???���Ӥp(�p�_inc_node)�A�Υu�Ѥ@?�A�Υu�Ѥ@???�A�h�X  
        H                   = hist(targets, length(Uc));  %???����??�A��??�_�C???��?��    H(1��???��)
        [m, largest]    = max(H); %�o��]�t?��?�̦h����???�����ޡA??largest �]�t�h��??���A??m
        tree.Nf         = [];  
        tree.split_loc  = [];  
        tree.child      = Uc(largest);%�h�B������^�䤤�]�t?��?�̦h�@?�@?��?? 
        return  
    end  
      
    %Compute the node's I  
    for i = 1:length(Uc) %�M?�P???��?�� 
        Pnode(i) = length(find(targets == Uc(i))) / L;  %�o��?�e�Ҧ�?���� ??=��i??? ��?����?��  �e?��??�����  �s��bPnode(i)��
    end  
%   ?��?�e���H���i�]��?����H���^
% 	�Ҧp�A?�u��D�]�t14????���A9??�_??��Yes���A5??�_??��No���AInode = -9/14 * log2(9/14) - 5/14 * log2(5/14) = 0.940
    Inode = -sum(Pnode.*log(Pnode)/log(2));  
      
    %For each dimension, compute the gain ratio impurity �H?�_�C?�A?��??���W�q��  ?�S�������C?�S����??��H���i
    %This is done separately for discrete and continuous patterns     �H?�_�ô��M??�S���A��??��
    delta_Ib    = zeros(1, Ni_choose);  %Ni�O�S��??  �Τ_??�C?�S�����H���W�q�v
    split_loc   = ones(1, Ni_choose)*inf;  %��l�ƨC?�S���������ȬOinf
      
    for i_idx = 1:Ni_choose%�M?�C?�S��  
        i = N_choose(i_idx);
        data    = patterns(i,:);  %�o��?�e�Ҧ�?����??�S�����S����
        Ud      = unique(data);   %�o��?���`���S�����ۦ��V�qUd
        Nbins   = length(Ud);     %�o��?���`���S���Ȫ�?��
        if (discrete_dim(i)) %�p�G??�S���O�ô��S�� 
            %This is a discrete pattern  
            P   = zeros(length(Uc), Nbins);  %Uc�O�P???��??   �P?????��?���`���S���Ȫ�?��
            for j = 1:length(Uc) %�M?�C???  
                for k = 1:Nbins %�M?�C?�S����  
                    indices     = find((targets == Uc(j)) & (patterns(i,:) == Ud(k)));  
                    % &��Τ_�x??��???�� &&����ΡA�u��Τ_??���� &���N��]�O�O
                    %��� �]?��??==��j???  �}�B ?�e�Ҧ�?����??�S��==��k?�S���ȡ^ ��?��??
                    P(j,k)  = length(indices);  %??P(j,k)
                end  
            end  
            Pk          = sum(P);  %��P���C�@�C���M�A�]�N�O�o��?�e�Ҧ�?�����A??�S�����S����==??�S���Ȫ�?��?��   Pk(1�ѯS����?��)���??�S�����S���ȵ��_�C?�S���Ȫ�?��?��
            P1          = repmat(Pk, length(Uc), 1);  %��Pk�`� �P????? ��
            P1          = P1 + eps*(P1==0);  %?�D�n�b�O?P1�@�Q��??�����_0
            P           = P./P1;  %�o��?�e�Ҧ�?�����A??�S�����ȵ��_�C?�S���ȥB??���_�C???��?���A�e?�e??�S���Ȥ���?�������
            Pk          = Pk/sum(Pk);  %�o��?�e�Ҧ�?�����A??�S�����ȵ��_�C?�S���Ȫ�?���A�e?�e?��??�����
            info        = sum(-P.*log(eps+P)/log(2));  %?�S�������C?�S����??��H���i  info(1�ѯS����?��)
            delta_Ib(i_idx) = (Inode-sum(Pk.*info))/(-sum(Pk.*log(eps+Pk)/log(2))); %?��o��?�e�S�����H���W�q�v
            %?��H���W�q�v(GainRatio)�A����?Gain(A)/I(A),
            %�䤤Gain(A)=Inode-sum(Pk.*info)�N�O?��A���H���W�q
            %�䤤I(A)=-sum(Pk.*log(eps+Pk)/log(2))??��A���ҥ]�t���H��
        else   %?�_??�S��(�D�n�n���X�쪺�����ȡA��?�u�ô���)
            %This is a continuous pattern  
            P   = zeros(length(Uc), 2);  %   P(�P????�ء�2)  �C1�N��e..??������??������?   �C2�N���e..??�����~��??������?  ??..�N�O�U?������m
      
            %Sort the patterns  
            [sorted_data, indices] = sort(data);  %data���s�񪺬O?�e�Ҧ�???����??�S�����S����   ?�p��j�Ƨ�  sorted_data�O�ƧǦn��?�u indices�O����
            sorted_targets = targets(indices);  %?�M�A�P???�]�n???��?��?���?��
      
            %Calculate the information for each possible split  ?������H���׶q
              I = zeros(1,Nbins);
              delta_Ib_inter    = zeros(1, Nbins);
              for j = 1:Nbins-1
                  P(:, 1) = hist(sorted_targets(find(sorted_data <= Ud(j))) , Uc);  %??<=?�e�S���Ȫ�?����??��������?
                  P(:, 2) = hist(sorted_targets(find(sorted_data > Ud(j))) , Uc);  %??>?�e�S���Ȫ�?����??��������?
                  Ps      = sum(P)/L;  %sum(P)�O�o�������m�e���M�Z���U��?��?�e?�e?��??�����
                  P       = P/L;  %�e?��??�����
                  Pk      = sum(P);   %%sum(P)�O�o�������m�e���M�Z���U���h��??�� ��� 
                  P1      = repmat(Pk, length(Uc), 1);  %��Pk�`� �P????? ��
                  P1      = P1 + eps*(P1==0);  
                  info    = sum(-P./P1.*log(eps+P./P1)/log(2));  %?��H���i�]��?����H���^
                  I(j)    = Inode - sum(info.*Ps);  %Inode-sum(info.*Ps)�N�O�H��j??�����������H���W�q   
                  delta_Ib_inter(j) =  I(j)/(-sum(Ps.*log(eps+Ps)/log(2))); %?��o��?�e�S���Ȫ��H���W�q�v
              end

            [~, s] = max(I);  %���H���W�q�̤j���E����k  delta_Ib(i)���s�񪺬O?�_?�e��i?�S���Ө��A�̤j���H���W�q�@???�S�����H���W�q  s�s��??�E����k
            delta_Ib(i_idx) = delta_Ib_inter(s);  %�o��??��?�S����??���H���W�q�v
            split_loc(i_idx) = Ud(s);  %??�S��i���E����m�N�O��ϫH���W�q�̤j���E����
        end  
    end  
      
    %Find the dimension minimizing delta_Ib    %���?�e�n�@?�����S�����S��
    [m, dim]    = max(delta_Ib);  %���Ҧ��S�����̤j���H���W�q??���S���A??dim
    dims        = 1:Ni_choose;  %Ni�S��?��
    dim_all = 1:N_all;
    dim_to_all = N_choose(dim);
    tree.dim = dim_to_all;  %???�������S��
      
    %Split along the 'dim' dimension  
    Nf      = unique(patterns(dim_to_all,:));  %�o��??��??�@?�����S�����S�������@��  �]�N�O�o��?�e�Ҧ�?����??�S�����S����
    Nbins   = length(Nf);  %�o��??�S����?���`���S���Ȫ�?��
    tree.Nf = Nf;  %???����?�S���V�q ?�e�Ҧ�?����??�S�����S����
    tree.split_loc      = split_loc(dim);  %��??�S�����E����m???��������m  �i�O�p�G??���O�@?�ô��S���Asplit_loc(dim)�O��l��inf�ڡH�H�H
      
    %If only one value remains for this pattern, one cannot split it.  
    if (Nbins == 1)  %?���`���S���Ȫ�?��==1�A�Y??�S���u��?�@?�S���ȡA�N����?�����
        H               = hist(targets, length(Uc));  %???�e�Ҧ�?����??�A��??�_�C???��?��    H(1��???��)
        [m, largest]    = max(H);  %�o��]�t?��?�̦h����???�����ޡA??largest �]�t�h��??���A??m
        tree.Nf         = [];  %�]?���H??�S��?������A�ҥHNf�Msplit_loc��?��
        tree.split_loc  = [];  
        tree.child      = Uc(largest);  %�h�B???�S����??�N??�]�t?��?�̦h����???
        return  
    end  
      
    if (discrete_dim(dim_to_all))  %�p�G?�e??��??�@?�����S�����S���O?�ô��S�� 
        %Discrete pattern  
        for i = 1:Nbins   %�M???�S���U?���`���S���Ȫ�?��
            indices         = find(patterns(dim_to_all, :) == Nf(i));  %���?�e�Ҧ�?����??�S�����S����?Nf(i)������?
            tree.child(i)   = make_tree(patterns(dim_all, indices), targets(indices), inc_node, discrete_dim(dim_all), maxNbin, base, flag);%??
            %�]??�O?�ô��S���A�ҥH���e��Nbins?�A��???�C?�S���Ȩ���?���A?��A���e
        end  
    else  
        %Continuous pattern  %�p�G?�e??��??�@?�����S�����S���O???�S�� 
        indices1            = find(patterns(dim_to_all,:) <= split_loc(dim));  %���S����<=�����Ȫ�?��������?
        indices2            = find(patterns(dim_to_all,:) > split_loc(dim));   %���S����>�����Ȫ�?��������?
        if ~(isempty(indices1) | isempty(indices2))  %�p�G<=������ >�����Ȫ�?��?�س������_0  
            tree.child(1)   = make_tree(patterns(dim_all, indices1), targets(indices1), inc_node, discrete_dim(dim_all), maxNbin, base+1, flag);%?? 
            %?<=�����Ȫ�?��?��A���e
            tree.child(2)   = make_tree(patterns(dim_all, indices2), targets(indices2), inc_node, discrete_dim(dim_all), maxNbin, base+1, flag);%?? 
            %?>�����Ȫ�?��?��A���e
        else  
            H               = hist(targets, length(Uc));  %???�e�Ҧ�?����??�A��??�_�C???��?��    H(1��???��)
            [m, largest]    = max(H);   %�o��]�t?��?�̦h����???�����ޡA??largest �]�t�h��??���A??m
            tree.child      = Uc(largest);  %�h�B???�S����??�N??�]�t?��?�̦h����???  
            tree.dim                = 0;  %?�������S��??0
        end  
    end  
